# Reloj-Vital

## Alumnos
- Hernández Solís Miguel Ángel
- Marín Reyes Saúl Guadalupe
- Rojas Sánchez Oscar Adahir

## Visión
Mejorar la salud y el bienestar de los usuarios mediante un monitoreo integral y recomendaciones personalizadas basadas en datos en tiempo real. La aplicación Reloj Vital proporcionará a los usuarios información precisa sobre su frecuencia cardíaca y actividad física, junto con alertas y recomendaciones para fomentar hábitos de vida saludables.

## Software Empleado
- **Flutter**: Utilizado para el desarrollo de la aplicación móvil y smartwatch, permitiendo una experiencia de usuario consistente en ambas plataformas.
- **Dart**: Lenguaje de programación utilizado en Flutter.
- **Android Studio**: Entorno de desarrollo integrado (IDE) para desarrollar, probar y depurar la aplicación en dispositivos Android y emuladores.
- **GitHub**: Para el control de versiones y colaboración en el desarrollo del proyecto.
- **Trello**: Para la gestión de tareas y organización del flujo de trabajo en el equipo.
- **Arduino IDE**: Utilizado para programar la ESP32.
- **Node-RED**: Para la comunicación por MQTT entre la ESP32, base de datos y la apliación del móvil.

## Hardware Empleado
- **Smartphone Android**: Dispositivo móvil para instalar, probar y utilizar la aplicación.
- **ESP32**: Microcontrolador que servirá como el cerebro del dispositivo de monitoreo.
- **Sensor de Frecuencia Cardiaca (XD-58C)**: Para monitorear la frecuencia cardíaca en tiempo real.
- **Acelerómetro (MPU6050)**: Para registrar la actividad física.
- **DHT11**: Para monitorear temperatura ambiente en tiempo real.
- **Pantalla OLED SSD1306**: Para mostrar los datos del usuario como BPM, pasos que ha dado calorías quemadas y distancia recorrida.
- **Motor vibrador en forma de moneda**: Vibra en BPM fuera de rango normal (mayor a 100 BPM y menor a 60BPM).
- **Led**: Led amarillo para avisar al usuario si su BPM está fuera de rango normal (mayor a 100 BPM y menor a 60BPM).
- **Buzzer Pasivo**: Emite una melodía de Mario Bros cuando se cumple con la meta de calorías.
- **Protoboard**: Para facilitar la conexión entre sensores/actuadores con la ESP32.


## Historias de Usuario

1. Como usuario, quiero registrar mis datos como nombre, sexo, peso, estatura y meta de kilocalorías por día para visualizar mis resultados en tiempo real y resultados históricos.
2. Como usuario, quiero modificar mis datos para obtener mediciones más realistas. 
3. Como usuario, quiero monitorear mis latidos por minuto en tiempo real para estar al tanto de mi salud cardíaca.
4. Como usuario, quiero recibir alertas si mis latidos por minuto se encuentran fuera del rango normal para tomar las acciones pertinentes.
5. Como usuario, quiero ver mi historial de latidos por minuto para verificar cómo ha ido mi ritmo cardiaco a lo largo de los días.
6. Como usuario, quiero visualizar los pasos, calorías quemadas y distancia recorrida en tiempo real.
7. Como usuario, quiero recibir una alerta cuando he cumplido mi objetivo de calorías quemadas.
8. Como usuario, quiero ver mi historial de calorías quemadas
9. Como usuario, quiero visualizar la temperatura actual al abrir la aplicación móvil.

## Prototipo Propuesto
### Inicio
<p align="center">
<img src="" alt="Inicio" width="275" style="display: block; margin: 0 auto;">
</p>

### Registro de Datos de Usuario
<p align="center">
<img src="https://github.com/user-attachments/assets/b80967d8-bcdf-46a9-b1b0-d40ffafff75c" alt="Login" width="275" style="display: block; margin: 0 auto;">
</p>

### Ritmo Cardiaco
<p align="center">
  <img src="https://github.com/user-attachments/assets/08af4b09-60d7-44f7-96be-4e9e9df3ecce" alt="Inicio" width="275" style="display: block; margin: 0 auto;">
</p>

### Actividad Física
<p align="center">
  <img src="https://github.com/user-attachments/assets/bfa95476-fc3a-471a-a672-6c98c53168ec" alt="Actividad Física" width="275" style="display: block; margin: 0 auto;">
</p>

### Cuenta
<p align="center">
  <img src="https://github.com/user-attachments/assets/44e7b217-f37f-4683-80f7-a6ec751483ac" alt="Cuenta" width="275" style="display: block; margin: 0 auto;">
</p>

### Dispositivo elaborado
<p align="center">
  <img src="https://github.com/user-attachments/assets/9c8e2341-04d4-4fc0-9f0f-f8f8f18f05a2" alt="Dispositivo" width="275" style="display: block; margin: 0 auto;">
</p>

## Video Demostrativo


## Tablero en Trello
Puedes acceder al tablero de Trello del proyecto [aquí](https://trello.com/invite/b/hpRexQgs/ATTIb7adaa5f4b2b22b23f892c7a59e9495d7F344284/reloj-vital).
