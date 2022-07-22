#include "mpu9250.h"

#ifdef _ESP32_HAL_I2C_H_
#define SDA_PIN 21
#define SCL_PIN 22
#endif

MPU9250_asukiaaa mySensor;
float aX, aY, aZ, aSqrt, gX, gY, gZ, mDirection, mX, mY, mZ;

void setup()
{
  Serial.begin(115200);
  while (!Serial)
    Serial.println("started");

#ifdef _ESP32_HAL_I2C_H_ // For ESP32
  Wire.begin(SDA_PIN, SCL_PIN);
  mySensor.setWire(&Wire);
#endif

  mySensor.beginAccel();
  mySensor.beginGyro();
  Wire.beginTransmission(0x68);
  Wire.write(0x37);
  Wire.write(0x02);
  Wire.endTransmission();
  mySensor.beginMag();

  // You can set your own offset for mag values
  // mySensor.magXOffset = -50;
  // mySensor.magYOffset = -55;
  // mySensor.magZOffset = -10;
}

void loop()
{
  uint8_t sensorId;
  int result;

  result = mySensor.readId(&sensorId);
//  if (result == 0)
//  {
//    Serial.println("sensorId: " + String(sensorId));
//  }
//  else
//  {
//    Serial.println("Cannot read sensorId " + String(result));
//  }

//  result = mySensor.accelUpdate();
//  if (result == 0)
//  {
//    aX = mySensor.accelX();
//    aY = mySensor.accelY();
//    aZ = mySensor.accelZ();
//    aSqrt = mySensor.accelSqrt();
//    Serial.println("accelX: " + String(aX));
//    Serial.println("accelY: " + String(aY));
//    Serial.println("accelZ: " + String(aZ));
//    Serial.println("accelSqrt: " + String(aSqrt));
//  }
//  else
//  {
//    Serial.println("Cannod read accel values " + String(result));
//  }
//
//  result = mySensor.gyroUpdate();
//  if (result == 0)
//  {
//    gX = mySensor.gyroX();
//    gY = mySensor.gyroY();
//    gZ = mySensor.gyroZ();
//    Serial.println("gyroX: " + String(gX));
//    Serial.println("gyroY: " + String(gY));
//    Serial.println("gyroZ: " + String(gZ));
//  }
//  else
//  {
//    Serial.println("Cannot read gyro values " + String(result));
//  }

  result = mySensor.magUpdate();
  if (result == 0)
  {
    mX = mySensor.magX();
    mY = mySensor.magY();
    mZ = mySensor.magZ();
    mDirection = mySensor.magHorizDirection();
    Serial.print(mX, 4);
    Serial.print(", ");
    Serial.print(mY, 4);
    Serial.print(", ");
    Serial.println(mZ, 4);
//    Serial.println(", horizontal direction: " + String(mDirection));
  }
  else
  {
    Serial.println("Cannot read mag values " + String(result));
  }

//  Serial.println("at " + String(millis()) + "ms");
//  Serial.println(""); // Add an empty line
  delay(200);
}
