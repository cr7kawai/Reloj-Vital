#define LED_PIN   5  // Pin del LED
#define MOTOR_PIN 4 // Pin del motor de vibración

void setup() {
  // Configura los pines como salida
  pinMode(LED_PIN, OUTPUT);
  pinMode(MOTOR_PIN, OUTPUT);

  Serial.begin(115200); // Inicia la comunicación serial
  Serial.println("Prueba de actuadores: LED y motor de vibración");
}

void loop() {
  // Enciende el LED y el motor de vibración
  digitalWrite(LED_PIN, HIGH);
  digitalWrite(MOTOR_PIN, HIGH);
  Serial.println("LED y motor encendidos");
  delay(1000); // Mantiene ambos encendidos durante 1 segundo

  // Apaga el LED y el motor de vibración
  digitalWrite(LED_PIN, LOW);
  digitalWrite(MOTOR_PIN, LOW);
  Serial.println("LED y motor apagados");
  delay(1000); // Mantiene ambos apagados durante 1 segundo
}
