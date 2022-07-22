#include "mpu9250.h"
#include "madgwick.h"

#ifdef _ESP32_HAL_I2C_H_
#define SDA_PIN 21
#define SCL_PIN 22
#endif

MPU9250_asukiaaa mySensor;
Madgwick MadgwickFilter;
float aX, aY, aZ, aSqrt, gX, gY, gZ, mDirection, mX, mY, mZ;
unsigned long nowTime, oldTime;
float dt;
int count = 0;

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
  nowTime = micros();
  dt = (float)(nowTime - oldTime) / 1000000.0; // [µs]to[s]
  oldTime = nowTime;

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

  result = mySensor.accelUpdate();
  if (result == 0)
  {
    aX = mySensor.accelX();
    aY = mySensor.accelY();
    aZ = mySensor.accelZ();
    aSqrt = mySensor.accelSqrt();
  }
  else
  {
    Serial.println("Cannod read accel values " + String(result));
  }

  result = mySensor.gyroUpdate();
  if (result == 0)
  {
    gX = mySensor.gyroX();
    gY = mySensor.gyroY();
    gZ = mySensor.gyroZ();
  }
  else
  {
    Serial.println("Cannot read gyro values " + String(result));
  }

  result = mySensor.magUpdate();
  if (result == 0)
  {
    // mX = mySensor.magX();
    // mY = mySensor.magY();
    // mZ = mySensor.magZ();
    mySensor.magCalibrate();
    mX = mySensor.Calib_magX();
    mY = mySensor.Calib_magY();
    mZ = mySensor.Calib_magZ();
    mDirection = mySensor.magHorizDirection();
  }
  else
  {
    Serial.println("Cannot read mag values " + String(result));
  }

  MadgwickFilter.update(gX, gY, gZ, aX, aY, aZ, mX, mY, mZ, dt);
  if (count % 10 == 0)
  {
    // MadgwickFilter.printQuaternion();
    Serial.println(gZ);
  }
  delay(10);
  count++;
}
