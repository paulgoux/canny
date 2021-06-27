import processing.sound.*;
import processing.video.*;
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.AWTException;

PImage screenshot;
Rectangle dimension;
Robot robot;

PShader myShader, gaus;
PGraphics c, c1;
PImage img;
webcam cam;
Movie myMovie;
BMS b;
tab t;
sliderBox sl1;

PShader blur;
PGraphics src;
PGraphics pass1, pass2;

void setup() {
  size(700, 700, P2D);
  img = loadImage("i.png");
  b = new BMS(this, true);
  c = createGraphics(width, height, P2D);
  c1 = createGraphics(width, height, P2D);
  myShader = loadShader("input_sound.glsl");
  gaus = loadShader("gaussian.glsl");
  myMovie = new Movie(this, "data.mp4");
  //myMovie.play();
  surface.setLocation(width-20, 0);

  myShader.set("iResolution", float(width), float(height), 0.0);
  t = new tab(0, 90, 250, 500, "Sliders", b);
  t.toggle = true;
  t.draggable = true;
  String[] sl1Labels = {"mult", "intensity", "min", "vidPos", "type", "Blur R", 
    "Sigma"};
  sl1 = new sliderBox(90, 40, 90, 20, 10, sl1Labels, b);
  //sl1.setPieSquare();
  //sl1.setClassicBar();
  t.add(sl1);
  b.add(t);
  //t.getSlider(0, 0).setEnd(20);
  //t.getSlider(0, 0).value = 0;
  screenshot = createImage(displayWidth/2, displayHeight, ARGB);
  dimension  = new Rectangle(displayWidth/2, displayHeight);

  try {
    robot = new Robot();
  }
  catch (AWTException cause) {
    println(cause);
    exit();
  }

  blur = loadShader("gaussian.glsl");

  src = createGraphics(width, height, P2D); 
  img = loadImage("sea.jpg");
  pass1 = createGraphics(width, height, P2D);
  pass1.noSmooth();  

  pass2 = createGraphics(width, height, P2D);
  pass2.noSmooth();

  b.bg = false;
  //cam = new webcam(this);
}

float w = 100;
float h = 100;
float a = width/2-w/2;
float a1 = height/2-h/2;

float min = 1, mult = 1.0;
float pos = 0;
int type = 0;
void draw() {
  background(50);
  //cam.display();
  //if(cam.cam.available() == true)
  t.set(0, 0, 0, 20);
  t.set(0, 1, 0, 20);
  t.set(0, 2, -50, 50);
  t.set(0, 3, 0, myMovie.duration());
  t.setInt(0, 4, 0, 5);
  t.setInt(0, 5, 0, 10);
  t.set(0, 6, -5, 5);
  //t.setPie(0,0,0, 20);
  //t.setPie(0,1,0, 20);
  //t.setPie(0,2,-50,50);
  //t.setPie(0,3,0, myMovie.duration());
  //t.setPieInt(0,4,0, 5);

  //if (t.getSlider(0, 3).mdown&&!mousePressed)
  //  myMovie.jump(t.getSlider(0, 3).value);
  //img = myMovie;
  img = grabScreenshot(screenshot, dimension, robot);
  //img.resize(100,0);
  //if (frameCount>2
  //    &&(pmouseX!=mouseX
  //    ||pmouseY!=mouseY)
  //    ||img==myMovie) {
  if (frameCount>2
    ||img==myMovie) {
    myShader.set("mult", t.getSlider(0, 0).value);
    myShader.set("INTENSITY", t.getSlider(0, 1).value);
    myShader.set("MIN", t.getSlider(0, 2).value);
    myShader.set("type", (t.getSlider(0, 4).value));
    
    blur.set("blurSize", (int)t.getSlider(0, 5).value);
    blur.set("sigma", t.getSlider(0, 6).value); 
    //c.beginDraw();
    //c.image(img, 0, 0);
    ////c.shader(blur);
    //c.endDraw();
    //blur(c, c1);
    //c.shader(myShader);

    // Draw the output of the shader onto a rectangle that covers the whole viewport.
    //c.rect(a, a1, width, height);
    //c.resetShader();
    c.beginDraw();
    c.background(0);
    c.fill(255);
    c.image(img, 0, 0);
    c.ellipse(mouseX, mouseY, 100, 100);
    c.endDraw();
    blur.set("horizontalPass", 0);
    pass1.beginDraw();            
    pass1.shader(blur);  
    pass1.image(c, 0, 0);
    pass1.endDraw();
    blur.set("horizontalPass", 1);
    pass2.beginDraw();            
    pass2.shader(blur);  
    pass2.image(pass1, 0, 0);
    pass2.endDraw();    

    //image(pass2, 0, 0);
    myShader.set("iChannel0", pass2);
    c1.beginDraw();
    c1.shader(myShader);
    //c1.image(pass2, 0, 0, width, height);
    c1.rect(a, a1, width, height);
    c1.resetShader();
    c1.endDraw();
  }
  //pushMatrix();

  //rotate(radians(180));
  //translate(a-width, a1-height);
  //translate(width, 0);
  //scale(-1, 1);
  image(c1, 0, 0);
  //popMatrix();
  b.run(mouseButton);
  b.theme.run();
  //image(audioDataTexture,0,0,width,height);
};

void movieEvent(Movie m) {
  m.read();
};

static final PImage grabScreenshot(PImage img, Rectangle dim, Robot bot) {
  //return new PImage(bot.createScreenCapture(dim));

  bot.createScreenCapture(dim).getRGB(0, 0
    , dim.width, dim.height
    , img.pixels, 0, dim.width);

  img.updatePixels();

  return img;
}
