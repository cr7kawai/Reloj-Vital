#include <Wire.h>
#include <MPU6050.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include "DHT.h"
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

// Configuración del sensor DHT11
#define DHTPIN 18
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

// Configuración de la pantalla OLED
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1
#define SCREEN_ADDRESS 0x3C
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// Configuración del Buzzer
int pinSound = 15;
bool goalCompleted = false; // Para que solo se reproduzca una vez alcanzada la meta

// Configuración del MPU6050
MPU6050 mpu;

// Variables para el acelerómetro y conteo de pasos
const int stepThreshold = 35000;
int steps = 0;
int lastReading = 0;

// Variables para el sensor de pulso
#define PulseSensor_PIN 36
#define LED_PIN         5
#define MOTOR_PIN       4
#define PULSO_PIN       2
int Signal;
int UpperThreshold = 860;
int LowerThreshold = 850;
unsigned long lastBeatTime = 0;
int beatCount = 0;
int bpm = 0;

// Definir el rango saludable de BPM
const int minBPM = 60;
const int maxBPM = 100;

// Variables para el tiempo
unsigned long startMillis;
unsigned long currentMillis;
const unsigned long interval = 60000;
const unsigned long dhtInterval = 1000;
const unsigned long calcInterval = 2000;

// Configuración de Wi-Fi y MQTT
const char* ssid = "Lenovo";
const char* password = "Hola1234";
const char* mqtt_server = "broker.emqx.io";
const int mqtt_port = 1883;
const char* steps_request_topic = "relojVital/get/mpu6050";
const char* steps_result_topic = "relojVital/resultado/get/mpu6050";
const char* user_request_topic = "relojVital/get/usuario";
const char* user_response_topic = "relojVital/resultado/get/usuario";

WiFiClient espClient;
PubSubClient client(espClient);

// Variables para los datos del usuario
String name = "";
int height = 0;
int weight = 0;
int goal = 0;
bool registered = false;

// Variables para control extra
unsigned long lastDhtMillis = 0;
unsigned long lastCalcMillis = 0;

void setup() {
  Serial.begin(115200);
  delay(1000);
  Wire.begin(23, 25);

  // Inicialización del MPU6050
  mpu.initialize();
  if (mpu.testConnection()) {
    Serial.println("MPU6050 conectado correctamente");
  } else {
    Serial.println("Error de conexión con el MPU6050");
  }

  dht.begin();
  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);

  reconnect(); // Conéctate y haz la petición al tópico
  client.publish(user_request_topic, "");

  // Verificar si se ha iniciado el display
  if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
    Serial.println(F("No se pudo inicializar la pantalla OLED"));
    for (;;);
  }

  display.clearDisplay();

  // Configuración para el sensor de pulso
  analogReadResolution(10);
  pinMode(LED_PIN, OUTPUT);
  pinMode(MOTOR_PIN, OUTPUT);
  pinMode(PULSO_PIN, OUTPUT);
  pinMode (pinSound,OUTPUT); 
  startMillis = millis(); // Inicializa el temporizador
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  if(registered){
    // 1. Manejo del Acelerómetro (Conteo de pasos)
    int16_t ax, ay, az;
    mpu.getAcceleration(&ax, &ay, &az);
    int magnitude = sqrt(ax * ax + ay * ay + az * az);

    if (magnitude > stepThreshold) {
      steps++;
      Serial.print("Pasos: ");
      Serial.println(steps);
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

    if (currentMillis - startMillis >= interval) {
      bpm = beatCount;
      Serial.print("BPM: ");
      Serial.println(bpm);
      String bpmPayload = "{\"valor\": " + String(bpm) + "}";
      client.publish("relojVital/post/xd58c", bpmPayload.c_str());

      if (bpm < minBPM || bpm > maxBPM) {
        digitalWrite(MOTOR_PIN, HIGH);
        digitalWrite(LED_PIN, HIGH);
        delay(3000);
        digitalWrite(MOTOR_PIN, LOW);
        digitalWrite(LED_PIN, LOW);
      } else {
        digitalWrite(MOTOR_PIN, LOW);
        digitalWrite(LED_PIN, LOW);
      }

      beatCount = 0;
      startMillis = currentMillis;
    }


    // 3. Cálculo de calorías quemadas y distancia recorrida
    if (currentMillis - lastCalcMillis >= calcInterval) {
      // Calcular calorías quemadas
      int caloriasQuemadas = ((weight * 0.49) * (steps / 1000.00));

      // Calcular distancia recorrida
      float distanciaRecorrida = steps * ((height * 0.38) / 100000.0);

      // Si se ha cumplido la meta, tocar melodía de completado
      if(caloriasQuemadas == goal && goalCompleted == false){
        melody_marioBros();
        goalCompleted = true;
      }

      // Mostrar datos en el display
      showMetrics(bpm, caloriasQuemadas, steps, distanciaRecorrida);

      lastCalcMillis = currentMillis;
    }
  }

  // 4. Manejo del Sensor DHT11
  if (currentMillis - lastDhtMillis >= dhtInterval) {
    float temperatura = dht.readTemperature();
    if (isnan(temperatura)) {
      Serial.println("Error al leer la temperatura!");
    } else {
      int tempEntera = int(temperatura);

      String dhtPayload = "{\"valor\": " + String(tempEntera) + "}";
      client.publish("relojVital/get/dht11", dhtPayload.c_str());
    }
    lastDhtMillis = currentMillis;
  }

  delay(40);
}

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

void callback(char* topic, byte* payload, unsigned int length) {
  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }

  if (String(topic) == user_response_topic) {
    DynamicJsonDocument doc(1024);
    deserializeJson(doc, message);

    name = doc["nombre"].as<String>();
    height = doc["estatura"].as<int>();
    weight = doc["peso"].as<int>();
    goal = doc["meta"].as<int>();
    registered = doc["registrado"].as<bool>();

    Serial.print("Registrado: ");
    Serial.println(registered ? "Sí" : "No");

  } else if (String(topic) == steps_result_topic) {
    int valor = message.toInt();
    steps = valor;
  }
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Intentando conectar al broker MQTT...");
    
    String clientId = "ESP32Client-";
    clientId += String(random(0xffff), HEX);
    
    if (client.connect(clientId.c_str())) {
      Serial.println("Conectado");
      client.subscribe(steps_result_topic);
      client.subscribe(user_response_topic);
      client.publish(steps_request_topic, "");
      client.publish(user_request_topic, "");
    } else {
      Serial.print("Error, rc=");
      Serial.print(client.state());
      Serial.println(" Intenta de nuevo en 5 segundos");
      delay(5000);
    }
  }
}

void tone(int pin, int frequency, float silencio) {
  ledcSetup(0, frequency, 8); // Configura el canal 0 con la frecuencia y resolución deseada
  ledcAttachPin(pin, 0);      // Asocia el canal 0 al pin especificado
  ledcWriteTone(0, frequency); // Reproduce el tono en el canal 0
}

void noTone(int pin) {
  ledcDetachPin(pin);  // Desasocia el pin para detener el tono
}

void melody_marioBros(){
  tone(pinSound, 659, 83.3333333333);
    delay(83.3333333333);
    delay(41.6666666667);
    tone(pinSound, 659, 83.3333333333);
    delay(83.3333333333);
    delay(166.666666667);
    tone(pinSound, 659, 83.3333333333);
    delay(83.3333333333);
    delay(166.666666667);
    tone(pinSound, 523, 83.3333333333);
    delay(83.3333333333);
    delay(41.6666666667);
    tone(pinSound, 659, 83.3333333333);
    delay(83.3333333333);
    delay(166.666666667);
    tone(pinSound, 783, 83.3333333333);
    delay(83.3333333333);
    delay(916.666666667);
    tone(pinSound, 523, 83.3333333333);
    delay(83.3333333333);
    delay(291.666666667);
    tone(pinSound, 391, 83.3333333333);
    delay(83.3333333333);
    delay(291.666666667);
    tone(pinSound, 329, 83.3333333333);
    delay(83.3333333333);
    delay(291.666666667);
    tone(pinSound, 440, 83.3333333333);
    delay(83.3333333333);
    delay(166.666666667);
    tone(pinSound, 493, 83.3333333333);
    delay(83.3333333333);
    delay(166.666666667);
    tone(pinSound, 466, 83.3333333333);
    delay(83.3333333333);
    delay(41.6666666667);
    tone(pinSound, 440, 83.3333333333);
    delay(83.3333333333);
    delay(166.666666667);
    tone(pinSound, 391, 83.3333333333);
    delay(83.3333333333);
    delay(83.3333333333);
    tone(pinSound, 659, 83.3333333333);
    delay(83.3333333333);
    delay(83.3333333333);
    tone(pinSound, 783, 83.3333333333);
    delay(83.3333333333);
    delay(83.3333333333);
    tone(pinSound, 880, 83.3333333333);
    delay(83.3333333333);
    delay(166.666666667);
    tone(pinSound, 698, 83.3333333333);
    delay(83.3333333333);
    delay(41.6666666667);
    tone(pinSound, 783, 83.3333333333);
    delay(83.3333333333);
    delay(166.666666667);
    tone(pinSound, 659, 83.3333333333);
    delay(83.3333333333);
    delay(166.666666667);
    tone(pinSound, 523, 83.3333333333);
    delay(83.3333333333);
    delay(41.6666666667);
    tone(pinSound, 587, 83.3333333333);
    delay(83.3333333333);
    delay(41.6666666667);
    tone(pinSound, 493, 83.3333333333);
    delay(83.3333333333);
    delay(291.666666667);
    noTone(pinSound);
}

void showMetrics(int bpm, int calories, int steps, float distance) {
  display.clearDisplay();

  display.setTextSize(1); // Tamaño de texto pequeño
  display.setTextColor(SSD1306_WHITE);

  // Cálculo del texto centrado
  String bpmText = "BPM: " + String(bpm);
  String caloriesText = "Calorias: " + String(calories);
  String stepsText = "Pasos: " + String(steps);
  String distanceText = "Distancia: " + String(distance, 2) + " km";

  int lineHeight = 10; // Altura de cada línea de texto
  int totalHeight = lineHeight * 4; // Altura total del texto
  int y = (SCREEN_HEIGHT - totalHeight) / 2; // Posición inicial vertical

  display.setCursor((SCREEN_WIDTH - bpmText.length() * 6) / 2, y);
  display.print(bpmText);

  y += lineHeight;
  display.setCursor((SCREEN_WIDTH - caloriesText.length() * 6) / 2, y);
  display.print(caloriesText);

  y += lineHeight;
  display.setCursor((SCREEN_WIDTH - stepsText.length() * 6) / 2, y);
  display.print(stepsText);

  y += lineHeight;
  display.setCursor((SCREEN_WIDTH - distanceText.length() * 6) / 2, y);
  display.print(distanceText);

  display.display();
}
