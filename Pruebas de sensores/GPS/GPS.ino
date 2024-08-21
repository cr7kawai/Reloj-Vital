#include <SoftwareSerial.h>
#include <TinyGPS.h>

TinyGPS gps;
SoftwareSerial softSerial(19, 21); // TX, RX

void setup()
{
  Serial.begin(115200);
  softSerial.begin(9600);
}

void loop()
{
  bool newData = false;
  unsigned long chars;
  unsigned short sentences, failed;
  
  // Intentar recibir secuencia durante un segundo
  for (unsigned long start = millis(); millis() - start < 1000;)
  {
    while (softSerial.available())
    {
      char c = softSerial.read();
      if (gps.encode(c)) // Nueva secuencia recibida
        newData = true;
    }
  }

  if (newData)
  {
    float flat, flon, lat, lon;
    unsigned long age;
    gps.f_get_position(&flat, &flon, &age);
    Serial.print(" LAT=");
    flat == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flat, 6;
    Serial.println(flat == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flat, 6);
    Serial.println(flat,6);
    Serial.println();
    Serial.print(" LON=");
    Serial.println(flon == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flon, 6);
    Serial.print(" SAT=");
    Serial.println(gps.satellites() == TinyGPS::GPS_INVALID_SATELLITES ? 0 : gps.satellites());
    Serial.print(" PREC=");
    Serial.println(gps.hdop() == TinyGPS::GPS_INVALID_HDOP ? 0 : gps.hdop());
  }

  gps.stats(&chars, &sentences, &failed);
  Serial.print(" CHARS=");
  Serial.print(chars);
  Serial.print(" SENTENCES=");
  Serial.print(sentences);
  Serial.print(" CSUM ERR=");
  Serial.println(failed);
}