#include "DHT.h"

// Definir el pin donde está conectado el sensor DHT11
#define DHTPIN 18  // Cambia este valor si estás usando otro pin

// Definir el tipo de sensor
#define DHTTYPE DHT11

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(115200);
  dht.begin();
}

void loop() {
  // Esperar un poco entre lecturas
  delay(2000);

  // Leer la temperatura
  float temperatura = dht.readTemperature();

  // Comprobar si la lectura es válida
  if (isnan(temperatura)) {
    Serial.println("Error al leer la temperatura!");
  } else {
    // Convertir la temperatura a entero para eliminar los decimales
    int tempEntera = int(temperatura);
    Serial.print("Temperatura: ");
    Serial.print(tempEntera);
    Serial.println(" °C");
  }
}
