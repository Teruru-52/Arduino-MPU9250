import processing.serial.*;
Serial serial;
PShape model;

String stringRoll;
String stringPitch;
String stringYaw;
float roll;
float pitch;
float yaw;

boolean drawValues  = false;

void setup() {
  //size(1400, 768);
  size(displayWidth, displayHeight, OPENGL);  
  println(Serial.list());
  serial = new Serial(this, Serial.list()[0], 115200);
  serial.bufferUntil('\n'); // Buffer until line feed
  
  model = loadShape("mpu9250.obj");
  //model = loadShape("mpu9250_2.obj");
  model.scale(0.2);
  
  draw();
}

void draw() {
  /* Draw Graph */
  if (drawValues) {
    drawValues = false;
    drawGraph();
  }
}

void drawGraph(){
  background(0);
  pushMatrix();
  lights();
  camera(0, 0, 100, 0, 0, 0, 0, 1, 0);
  translate(30, 18);
  
  roll = float(stringRoll);
  pitch = float(stringPitch);
  yaw = float(stringYaw);
  rotateZ(yaw);
  rotateY(pitch);
  rotateX(roll);
  //rotateX(roll);
  //rotateY(pitch);
  //rotateZ(yaw);
  shape(model);
  popMatrix();
  
  stroke(0);
  textSize(25);
  text("roll = " + stringRoll, 100, 80); 
  text("pitch = " + stringPitch, 100, 120); 
  text("yaw = " + stringYaw, 100,160);
}

void serialEvent(Serial serial){
  stringRoll = serial.readStringUntil('\t');
  stringPitch = serial.readStringUntil('\t');
  stringYaw = serial.readStringUntil('\t'); 
  
  serial.clear(); // Clear buffer
  drawValues = true;
}
