#define PulseSensor_PIN 36 
#define LED_PIN         2 

int Signal; //--> Accommodates the signal value (ADC value) from the pulse sensor.
int UpperThreshold = 575;
int LowerThreshold = 530;

unsigned long lastBeatTime = 0;
int beatCount = 0;
float bpm = 0.0;

unsigned long startMillis;
unsigned long currentMillis;
const unsigned long interval = 60000;

void setup() {
  Serial.begin(115200); //--> Set's up Serial Communication at certain speed.
  Serial.println();
  delay(2000);

  // Set the ADC resolution. "analogReadResolution(10);" meaning the ADC resolution is set at 10 bits (the ADC reading value is from 0 to 1023).
  analogReadResolution(10);

  // Set LED_PIN as Output.
  pinMode(LED_PIN,OUTPUT);
  
  startMillis = millis(); // Inicializa el temporizador
}

void loop() {
  currentMillis = millis(); // Obtiene el tiempo actual
  
  Signal = analogRead(PulseSensor_PIN); //--> Read the PulseSensor's value. Assign this value to the "Signal" variable.
  
  if(Signal > UpperThreshold){ //--> If the signal is above "575"(UpperThreshold), then "turn-on" the LED.
     digitalWrite(LED_PIN,HIGH);
     
     // Si el tiempo desde el último latido es mayor que un intervalo corto, contamos un nuevo latido
     if (currentMillis - lastBeatTime > 50) {
       beatCount++;
       lastBeatTime = currentMillis;
     }
  }

  if(Signal < LowerThreshold){
     digitalWrite(LED_PIN,LOW); //--> Else, the sigal must be below "530", so "turn-off" the LED.
  }

  // Calcula BPM cada minuto
  if (currentMillis - startMillis >= interval) {
    bpm = beatCount; // Calcula BPM
    Serial.print("BPM: ");
    Serial.println(bpm);
    beatCount = 0; // Reinicia el contador de latidos
    startMillis = currentMillis; // Reinicia el temporizador
  }
  
  delay(20); // Pequeña pausa para evitar lecturas excesivas
}
