int pinSound = 15; //Pin 9 de arduino para el + del zumbador

void setup() {
pinMode (pinSound,OUTPUT);     // Pin para reproducir la frecuencia del tono
melody_marioBros();
}
       
void loop() {
     
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
    noTone(15);
}