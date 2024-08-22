#include <Wire.h>
#include <MPU6050.h>
#include <WiFi.h>
#include <PubSubClient.h>

MPU6050 mpu;

// Variables para el acelerómetro y conteo de pasos
const int stepThreshold = 35000; // Ajusta este valor según el nivel de actividad
int steps = 0;
int lastReading = 0;

// Variables para los pines
#define PulseSensor_PIN 36 
#define LED_PIN         5 
#define MOTOR_PIN       4 
#define PULSO_PIN       2

// Variables para el sensor de pulso
int Signal;
int UpperThreshold = 850;
int LowerThreshold = 840;
unsigned long lastBeatTime = 0;
int beatCount = 0;
int bpm = 0;

unsigned long startMillis;
unsigned long currentMillis;
const unsigned long interval = 60000;

// Definir el rango saludable de BPM
const int minBPM = 60;
const int maxBPM = 100;

// Configura tu red Wi-Fi
const char* ssid = "Conectate a Dios";
const char* password = "Hola1234";

// Configura tu broker MQTT
const char* mqtt_server = "broker.emqx.io";
const int mqtt_port = 1883;
const char* request_topic = "relojVital/get/mpu6050";
const char* result_topic = "relojVital/resultado/get/mpu6050";

// Inicializa el cliente Wi-Fi y MQTT
WiFiClient espClient;
PubSubClient client(espClient);

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

  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);

  reconnect(); // Conéctate y haz la petición al tópico

  // Configuración para el sensor de pulso
  analogReadResolution(10);
  pinMode(LED_PIN, OUTPUT);
  pinMode(MOTOR_PIN, OUTPUT);
  pinMode(PULSO_PIN, OUTPUT);
  startMillis = millis(); // Inicializa el temporizador

}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

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

    // Publica los pasos cada 25 pasos
    if (steps % 25 == 0) {
      String payload = "{\"valor\": " + String(steps) + "}";
      client.publish("relojVital/post/mpu6050", payload.c_str());
    }
  }

  // 2. Manejo del Sensor de Pulso
  currentMillis = millis(); // Obtiene el tiempo actual

  Signal = analogRead(PulseSensor_PIN); // Lee el valor del sensor de pulso

  if (Signal > UpperThreshold) {
    digitalWrite(PULSO_PIN, HIGH);

    // Cuenta un nuevo latido si ha pasado suficiente tiempo
    if (currentMillis - lastBeatTime > 50) {
      beatCount++;
      lastBeatTime = currentMillis;
    }
  }

  if (Signal < LowerThreshold) {
    digitalWrite(PULSO_PIN, LOW);
  }

  // Calcula BPM cada minuto
  if (currentMillis - startMillis >= interval) {
    bpm = beatCount; // Calcula BPM
    Serial.print("BPM: ");
    Serial.println(bpm);

    // Publica los BPM
    String bpmPayload = "{\"valor\": " + String(bpm) + "}";
    client.publish("relojVital/post/xd58c", bpmPayload.c_str());

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

  delay(40); // Pequeña pausa para evitar lecturas excesivas
}


// Función para conectarse a la red Wi-Fi
void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Conectando a ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  
  Serial.println("");
  Serial.println("Conectado a la red Wi-Fi");
  Serial.print("Dirección IP: ");
  Serial.println(WiFi.localIP());
}

// Función para manejar los mensajes entrantes
void callback(char* topic, byte* payload, unsigned int length) {
  
  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  // Asignar los pasos obtenidos a la variable encargada del conteo
  steps = valor;
}

void reconnect() {
  // Loop hasta que esté conectado
  while (!client.connected()) {
    Serial.print("Intentando conectar al broker MQTT...");
    
    // Crea un identificador único para el cliente
    String clientId = "ESP32Client-";
    clientId += String(random(0xffff), HEX);
    
    // Intenta conectar
    if (client.connect(clientId.c_str())) {
      Serial.println("Conectado");
      // Suscríbete al tópico de resultados
      client.subscribe(result_topic);

      // Publica una solicitud para obtener el valor de los pasos
      client.publish(request_topic, "");
    } else {
      Serial.print("Error, rc=");
      Serial.print(client.state());
      Serial.println(" Intenta de nuevo en 5 segundos");
      // Espera 5 segundos antes de intentar conectar de nuevo
      delay(5000);
    }
  }
}