// 2018/11/04 imo lab.
//https://garchiving.com/

#include "Wire.h"
 int16_t mx, my, mz;

 void setup() {
  Wire.begin();
  TWBR = 24;
  Serial.begin(115200);
  setupMPU9255();
}

 void loop() {
  readCompass();
  Serial.print(mx); Serial.print(",");
  Serial.print(my); Serial.print(",");
  Serial.println(mz);
  delay(10);
}

 void readCompass() {
  Wire.beginTransmission(0x0C);
  Wire.write(0x02);
  Wire.endTransmission();
  Wire.requestFrom(0x0C, 1);

  uint8_t ST1 = Wire.read();
  if (ST1 & 0x01) {
    Wire.beginTransmission(0x0C);
    Wire.write(0x03);
    Wire.endTransmission();
    Wire.requestFrom(0x0C, 7);
    uint8_t i = 0;
    uint8_t buf[7];
    while (Wire.available()) {
      buf[i++] = Wire.read();
    }
    if (!(buf[6] & 0x08)) {
      mx = ((int16_t)buf[1] << 8) | buf[0];
      my = ((int16_t)buf[3] << 8) | buf[2];
      mz = ((int16_t)buf[5] << 8) | buf[4];
    }
  }
}

 void setupMPU9255() {
  Wire.beginTransmission(0x68);
  Wire.write(0x6B);
  Wire.write(0x00);
  Wire.endTransmission();

  Wire.beginTransmission(0x68);
  Wire.write(0x1A);
  Wire.write(0x05);
  Wire.endTransmission();

  Wire.beginTransmission(0x68);
  Wire.write(0x37);
  Wire.write(0x02);
  Wire.endTransmission();

  Wire.beginTransmission(0x0C);
  Wire.write(0x0A);
  Wire.write(0x16);
  Wire.endTransmission();
  delay(500);
}

//#include "Wire.h"
//int16_t x, y, z; // 地磁気ﾃﾞｰﾀ読み込み用変数（16bit）
//uint8_t dr;
//uint8_t i;
//void    setup()
//{
//  Wire.begin();
//  Serial.begin(115200);           // TeraTerm　ｼﾘｱﾙﾓﾆﾀｰ通信速度 9600
//  Wire.beginTransmission(0x0C); // I2Cスレーブに対して送信処理開始
//  Wire.write(0x0A);             // CNTL１レジスタ　モード設定
//  Wire.write(0x16);             // 0001 0110 16bit分解能、連続測定モード２
//  Wire.endTransmission();       // 送信実行
//  delay(1000);
//}
//void loop()
//{
//  Wire.beginTransmission(0x0C); // I2Cスレーブに対して送信処理開始
//  Wire.write(0x02);             // ST1ステータス１レジスタ
//  Wire.endTransmission();       // 送信実行
//  Wire.requestFrom(0x0C, 1);    // 1バイト　読み込み要求
//  dr = Wire.read();             // 読み込んだ値をdr(data ready)に取り込む
//  if (dr & 0x01)
//  { // ステータスレジスタ　DRDYビット：Data Ready 1　読み込みする
//    Wire.beginTransmission(0x0C); // I2Cスレーブに対して送信処理開始
//    Wire.write(0x03);             // 地磁気データ先頭レジスタ指定→６バイト連続で読み
//    Wire.endTransmission();       // 送信実行
//    Wire.requestFrom(0x0C, 7);    // 7バイト読み込みリクエスト →ST2レジスタまで読む
//
//    int16_t xh, xl; // 地磁気ﾃﾞｰﾀ x成分　２ﾊﾞｲﾄ読み込み
//    xl = Wire.read();
//    xh = Wire.read();
//    x = xh + 256 + xl; // 上位８ビット左シフト＋下位８ビット
//
//    int16_t yh, yl; // 地磁気ﾃﾞｰﾀ y成分　２ﾊﾞｲﾄ読み込み
//    yl = Wire.read();
//    yh = Wire.read();
//    y = yh * 256 + yl; // 上位８ビット左シフト＋下位８ビット
//
//    int16_t zh, zl; // 地磁気ﾃﾞｰﾀ z成分　２ﾊﾞｲﾄ読み込み
//    zl = Wire.read();
//    zh = Wire.read();
//    z = zh * 256 + zl; // 上位８ビット左シフト＋下位８ビット
//
//    int16_t st2 = Wire.read(); // 7ﾊﾞｲﾄ目　ST2レジスタまで読む　無くてもOK?
//    Serial.print(x);
//    Serial.print(",");
//    Serial.print(y);
//    Serial.print(",");
//    Serial.println(z);
//    delay(500);
//  }
//}
