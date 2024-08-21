#include <Wire.h>
#include <MPU6050.h>

MPU6050 mpu;

const int stepThreshold = 35000; // Ajusta este valor según el nivel de actividad
int steps = 0;
int lastReading = 0;

void setup() {
  Serial.begin(115200);
  delay(1000);
  Wire.begin(21, 22);
  
  mpu.initialize();
  
  if (mpu.testConnection()) {
    Serial.println("MPU6050 conectado correctamente");
  } else {
    Serial.println("Error de conexión con el MPU6050");
  }
}

void loop() {
  int16_t ax, ay, az;
  
  mpu.getAcceleration(&ax, &ay, &az);
  
  // Calcula la magnitud total de la aceleración
  int magnitude = sqrt(ax * ax + ay * ay + az * az);

  // Detecta pasos
  if (magnitude > stepThreshold) {
    steps++;
    Serial.print("Pasos: ");
    Serial.println(steps);
  }
  
  lastReading = magnitude;
  
  delay(20); // Ajusta el retardo según sea necesario
}
