#include <Wire.h>
#include <MPU6050.h>

MPU6050 mpu;

// Variables para el acelerómetro y conteo de pasos
const int stepThreshold = 35000; // Ajusta este valor según el nivel de actividad
int steps = 0;
int lastReading = 0;

// Variables para el sensor de pulso
#define PulseSensor_PIN 36 
#define LED_PIN         5 
#define MOTOR_PIN       4 
#define PULSO_PIN       2

int Signal; //--> Accommodates the signal value (ADC value) from the pulse sensor.
int UpperThreshold = 705;
int LowerThreshold = 685;

unsigned long lastBeatTime = 0;
int beatCount = 0;
float bpm = 0.0;

unsigned long startMillis;
unsigned long currentMillis;
const unsigned long interval = 60000;

// Definir el rango saludable de BPM
const int minBPM = 60;
const int maxBPM = 100;

void setup() {
  Serial.begin(115200);
  delay(1000);
  Wire.begin(21, 22);
  
  // Inicialización del MPU6050
  mpu.initialize();
  
  if (mpu.testConnection()) {
    Serial.println("MPU6050 conectado correctamente");
  } else {
    Serial.println("Error de conexión con el MPU6050");
  }

  // Configuración para el sensor de pulso
  analogReadResolution(10);
  pinMode(LED_PIN, OUTPUT);
  pinMode(MOTOR_PIN, OUTPUT);
  pinMode(PULSO_PIN, OUTPUT);
  startMillis = millis(); // Inicializa el temporizador
}

void loop() {
  // 1. Manejo del Acelerómetro (Conteo de pasos)
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
  
  // 2. Manejo del Sensor de Pulso
  currentMillis = millis(); // Obtiene el tiempo actual
  
  Signal = analogRead(PulseSensor_PIN); // Lee el valor del sensor de pulso
  
  if(Signal > UpperThreshold) {
    digitalWrite(PULSO_PIN, HIGH);
     
    // Cuenta un nuevo latido si ha pasado suficiente tiempo
    if (currentMillis - lastBeatTime > 50) {
       beatCount++;
       lastBeatTime = currentMillis;
    }
  }

  if(Signal < LowerThreshold) {
    digitalWrite(PULSO_PIN, LOW);
  }

  // Calcula BPM cada minuto
  if (currentMillis - startMillis >= interval) {
    bpm = beatCount; // Calcula BPM
    Serial.print("BPM: ");
    Serial.println(bpm);

    // Verifica si los BPM están fuera del rango saludable
    if (bpm < minBPM || bpm > maxBPM) {
      // Si está fuera del rango, enciende el motor y el LED
      digitalWrite(MOTOR_PIN, HIGH);
      digitalWrite(LED_PIN, HIGH);
      delay(3000);
      digitalWrite(MOTOR_PIN, LOW);
      digitalWrite(LED_PIN, LOW);
    } else {
      // Si está dentro del rango, apaga el motor y el LED
      digitalWrite(MOTOR_PIN, LOW);
      digitalWrite(LED_PIN, LOW);
    }

    beatCount = 0; // Reinicia el contador de latidos
    startMillis = currentMillis; // Reinicia el temporizador
  }
  
  delay(20); // Pequeña pausa para evitar lecturas excesivas
}
