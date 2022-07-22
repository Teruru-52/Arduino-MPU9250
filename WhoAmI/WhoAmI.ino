#include <Wire.h>
#define mpu_address 0x68


void setup()
{
  Wire.begin();

  Serial.begin(115200);
  Serial.println("Test start");

  write_mpu(0x6B,0x00);

}
void loop() {
  Serial.print("0x");
  Serial.println(read_mpu(0x75),HEX);
  Serial.println("-----");
  delay(1000);
}

void write_mpu(byte add, byte data) {
  Wire.beginTransmission(mpu_address);
  Wire.write(add);
  Wire.write(data);
  Wire.endTransmission();

}
byte read_mpu(byte add) {
  byte k;
  Wire.beginTransmission(mpu_address);
  Wire.write(add);
  Wire.endTransmission();
  Wire.requestFrom(mpu_address, 1);
  while (Wire.available()) {
    k = Wire.read();
  }
  return k;
}
