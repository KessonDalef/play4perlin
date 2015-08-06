/* 
** Perlin noise generative graphic
** Based on https://github.com/ReallyRad/playPerlin
**
** First commit on 06|08|2015
** by Kesson Dalef
** email: kessoning@gmail.com
*/

float noiseScale;
float par1, par2, par2next;
int lastTime;
int interval;
int resolution = 16;
float space;

ArrayList<PVector> points = new ArrayList();
ArrayList<PVector> xy = new ArrayList();

void setup() {
  size (600, 600, OPENGL);
  par1 = 0;
  par2 = 0;
  par2next = 0;
  lastTime=millis();
  smooth();
  colorMode(HSB, 255);
  rectMode(RADIUS);

  // Using vectors to make the sketch more scalable
  // For future developments
  for (int x=-3; x < width; x+=resolution) {
    for (int y=6; y < height; y += resolution) {
      points.add(new PVector(0, 0, 0));
      xy.add(new PVector(x, y));
    }
  }
}

void draw() {
  translate(width*0.5, height*0.5, width*0.65);
  rotate(radians(80.5), 0.51, 1, 0);
  background(0); 
  perspective(PI/3.0, (float) width/height, 0.1, 1000000); // perspective for close shapes
  //the following values are set here in order to be tweaked within tweak mode
  noiseScale=0.002;
  space=0.00;    
  interval = 2220;
  par1+=1.59; 

  if (millis()-lastTime>interval) { //event to jump to a new value with a smoothed transition
    lastTime=millis();    
    interval=(int)random(1000, 5000);
    par2next = random(par1, par1+ 900);
  }

  par2 += 0.00*(par2next-par2); //the value we're going through the perlin noise with

  for (int i = 0; i < points.size (); i++) {
    PVector p = points.get(i);
    PVector noisexy = xy.get(i);
    float noiseVal = noise((par1+noisexy.x)*noiseScale, par2*noiseScale, noisexy.y*noiseScale);
    stroke(255);
    pushMatrix();
    float translate = pow(noiseVal*6.7, 2.27);
    float xTranslate = cos(radians(noisexy.x))*translate;
    float yTranslate = sin(radians(noisexy.y))*translate;
    p.x = xTranslate;
    p.y = yTranslate;
    p.z = translate-(width/113.83333);
    translate(0, 0, 0);
    strokeWeight(1);
    point(p.x, p.y, p.z);
    popMatrix();

    // Create "mirrored" particles
    pushMatrix();
    p.z = -p.z;
    translate(p.x, p.y, p.z);
    point(0, 0, 0);
    popMatrix();
  }
}
