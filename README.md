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
- **NODE RED**: Para la comunicación por MQTT entre la ESP32 y la apliación del móvil.

## Hardware Empleado
- **Smartphone Android**: Dispositivo móvil para instalar, probar y utilizar la aplicación.
- **ESP32**: Microcontrolador que servirá como el cerebro del dispositivo de monitoreo.
- **Sensor de Frecuencia Cardiaca (XD-58C)**: Para monitorear la frecuencia cardíaca en tiempo real.
- **Acelerómetro (MPU6050)**: Para registrar la actividad física.
- **THT11**: Para monitorear temperatura
- **Motor vibrador en forma de moneda**: Vibra en BPM fuera de rango normal
- **Led**: Led amarillo para avisar al usuario si eta fuera de rango normal (alto o bajo)
- **buzzer**: Vibrara cuando se complete la meta de calorias

- 

## Historias de Usuario

1. Como usuario, quiero poder registrarme en la aplicación para acceder a todas sus funcionalidades.
2. Como usuario, quiero monitorear mi frecuencia cardíaca en tiempo real para estar al tanto de mi salud cardíaca.
3. Como usuario, quiero recibir alertas cuando mi ritmo cardíaco esté fuera de los rangos normales (muy alto o muy bajo) para poder actuar de inmediato.
4. Como usuario, quiero ver mis datos históricos en gráficos para obtener una visión clara de mi progreso a lo largo del tiempo.
5. Como usuario, quiero establecer y ajustar mis objetivos de salud y bienestar (como calorías a quemar), así como mi información personal para mantenerme motivado y enfocado.

## Prototipo Propuesto
### Registro de Usuarios
<p align="center">
<img src="https://github.com/user-attachments/assets/b80967d8-bcdf-46a9-b1b0-d40ffafff75c" alt="Login" width="275" style="display: block; margin: 0 auto;">

</p>

### Inicio y Ritmo Cardiaco
<p align="center">
  <img src="https://github.com/user-attachments/assets/08af4b09-60d7-44f7-96be-4e9e9df3ecce" alt="Inicio" width="475" style="display: block; margin: 0 auto;">
</p>

### Actividad Física
<p align="center">
  <img src="https://github.com/user-attachments/assets/bfa95476-fc3a-471a-a672-6c98c53168ec" alt="Actividad Física" width="275" style="display: block; margin: 0 auto;">
</p>

### Cuenta
<p align="center">
  <img src="https://github.com/user-attachments/assets/44e7b217-f37f-4683-80f7-a6ec751483ac" alt="Cuenta" width="275" style="display: block; margin: 0 auto;">
</p>

## Tablero en Trello
Puedes acceder al tablero de Trello del proyecto [aquí](https://trello.com/invite/b/hpRexQgs/ATTIb7adaa5f4b2b22b23f892c7a59e9495d7F344284/reloj-vital).
