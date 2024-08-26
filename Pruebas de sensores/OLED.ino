#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

// Configuración de la pantalla OLED
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1
#define SCREEN_ADDRESS 0x3C  // Cambia esto si la dirección es diferente

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// Valores de ejemplo
int bpm = 75;
int calories = 150;
int steps = 1234;
float distance = 10.65; // Distancia en kilómetros

void setup() {
  Serial.begin(115200);

  if (!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
    Serial.println(F("No se pudo inicializar la pantalla SSD1306"));
    for (;;);
  }

  display.clearDisplay();
}

void showMetrics(int bpm, int calories, int steps, float distance) {
  display.clearDisplay();

  display.setTextSize(1); // Tamaño de texto pequeño
  display.setTextColor(SSD1306_WHITE);

  // Cálculo del texto centrado
  String bpmText = "BPM: " + String(bpm);
  String caloriesText = "Calorías: " + String(calories);
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

void loop() {
  showMetrics(bpm, calories, steps, distance);
  delay(2000); // Actualiza cada 2 segundos
}
