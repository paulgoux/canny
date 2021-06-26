import processing.sound.*;
import processing.video.*;

PShader myShader, gaus;
PGraphics c;
PImage img;
webcam cam;
Movie myMovie;
void setup() {
  size(700, 400, P2D);
  img = loadImage("s1.jpg");
  c = createGraphics(width, height, P2D);
  myShader = loadShader("input_sound.glsl");
  gaus = loadShader("gaussian.glsl");
  myMovie = new Movie(this, "data.mp4");
  myMovie.play();
  myShader.set("iResolution", float(width), float(height), 0.0);
  //cam = new webcam(this);
}

float w = 100;
float h = 100;
float a = width/2-w/2;
float b = height/2-h/2;

float min = 1, mult = 1.0;
float pos = 0;
void draw() {
  background(50);
  //cam.display();
  //if(cam.cam.available() == true)
  if (mousePressed)myMovie.jump(map(mouseX, 0, width, 0, myMovie.duration()));
  min = map(mouseX, 0, width, 0, 1);
  mult = map(mouseY, 0, height, 1, 2);
  img = myMovie;
  if (frameCount>2) {
    myShader.set("mult", mult);
    myShader.set("MIN", min);
    myShader.set("iChannel0", img);
    c.beginDraw();
    //c.shader(gaus);
    c.shader(myShader);

    // Draw the output of the shader onto a rectangle that covers the whole viewport.
    c.rect(a, b, width, height);
    c.resetShader();
    c.endDraw();
  }
  pushMatrix();

  rotate(radians(180));
  translate(a-width, b-height);
  translate(width, 0);
  scale(-1, 1);
  image(c, 0, 0);
  popMatrix();
  //image(audioDataTexture,0,0,width,height);
};

void movieEvent(Movie m) {
  m.read();
};
