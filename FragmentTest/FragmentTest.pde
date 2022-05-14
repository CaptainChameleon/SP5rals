import processing.video.*;

Capture cam;
PImage img ;

PShader escher;

void setup() {
  size(640 , 480 , P2D);
  cam = new Capture(this, "pipeline:autovideosrc");
  cam.start();
  escher = loadShader("escher_fragment.glsl") ;
}

void draw() {
  escher.set("u_resolution", float(width), float(height));
  shader(escher);
  if (cam.available()) {
    background(0);
    cam.read ( );
    image(cam, 0, 0);
  }
}
