import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert'; // Importar el paquete para manejar JSON
import 'package:uuid/uuid.dart';

class MqttService {
  final MqttServerClient client;

  MqttService(String server)
      : client = MqttServerClient.withPort(server, '', 1883) {
    client.setProtocolV311();
    client.keepAlivePeriod = 20;
    client.logging(on: true);

    // Generar un identificador único
    final String clientId = Uuid().v4();
    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .keepAliveFor(20) // Mantener la conexión viva durante 20 segundos

        .startClean();

    client.connectionMessage = connMessage;
    print('::Inicializando correctamente con ID: $clientId::');
  }

  Future<void> connect() async {
    const maxAttempts = 6;
    int attempt = 0;
    bool connected = false;

    while (!connected && attempt < maxAttempts) {
      try {
        print('Intentando conectar, intento ${attempt + 1}...');
        await client.connect();
        if (client.connectionStatus?.state == MqttConnectionState.connected) {
          print('Conexión establecida con éxito');
          connected = true;
        } else {
          print(
              'Error en la conexión, estado: ${client.connectionStatus?.state}');
          client.disconnect();
        }
      } catch (e) {
        print('Error de conexión: $e');
        client.disconnect();
        attempt++;
        if (attempt < maxAttempts) {
          print('Reintentando en 5 segundos...');
          await Future.delayed(Duration(seconds: 5));
        }
      }
    }

    if (!connected) {
      print(
          'No se pudo establecer la conexión después de $maxAttempts intentos.');
    }
  }

  Future<void> ensureConnected() async {
    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      await connect();
    }
  }

  void onConnected() {
    print('Cliente conectado');
  }

  void onDisconnected() {
    print('Cliente desconectado');
  }

  void onSubscribed(String topic) {
    print('Suscrito al tópico: $topic');
  }

  void onUnsubscribed(String? topic) {
    print('Desuscrito del tópico: $topic');
  }

  void pong() {
    print('Ping recibido');
  }

  Stream<double> obtenerFrecuenciaCardiacaStream() async* {
    await ensureConnected();

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe('relojVital/resultado/post/xd58c', MqttQos.exactlyOnce);

      await for (final c in client.updates!) {
        final pubMessage = c[0].payload as MqttPublishMessage;
        final String message = MqttPublishPayload.bytesToStringAsString(
            pubMessage.payload.message);

        yield double.tryParse(message) ?? 0.0;
        print('Valor recibido: $message');
      }
    } else {
      print('No se pudo suscribir, estado: ${client.connectionStatus?.state}');
      client.disconnect();
    }
  }

  Stream<bool> obtenerUsuarioRegistradoStream() async* {
    await ensureConnected();

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe('relojVital/resultado/get/usuario', MqttQos.atMostOnce);

      final builder = MqttClientPayloadBuilder();
      client.publishMessage(
          'relojVital/get/usuario', MqttQos.atMostOnce, builder.payload!);

      await for (final c in client.updates!) {
        final pubMessage = c[0].payload as MqttPublishMessage;
        final String message = MqttPublishPayload.bytesToStringAsString(
            pubMessage.payload.message);

        final decodedMessage = jsonDecode(message);
        final bool registrado = decodedMessage['registrado'];

        yield registrado;
        print('Usuario registrado: $registrado');
      }
    } else {
      print('No se pudo suscribir, estado: ${client.connectionStatus?.state}');
      client.disconnect();
    }
  }

  Stream<double> obtenerTemperaturaStream() async* {
    await ensureConnected();

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe('relojVital/resultado/get/dht11', MqttQos.atMostOnce);

      await for (final c in client.updates!) {
        final pubMessage = c[0].payload as MqttPublishMessage;
        final String message = MqttPublishPayload.bytesToStringAsString(
            pubMessage.payload.message);

        yield double.tryParse(message) ?? 0.0;
        print('Temperatura recibida: $message °C');
      }
    } else {
      print('No se pudo suscribir, estado: ${client.connectionStatus?.state}');
      client.disconnect();
    }
  }

  Stream<Map<String, dynamic>> obtenerDatosActividadFisicaStream() async* {
    await ensureConnected();

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe(
          'relojVital/resultado/post/mpu6050', MqttQos.exactlyOnce);

      await for (final c in client.updates!) {
        final pubMessage = c[0].payload as MqttPublishMessage;
        final String message = MqttPublishPayload.bytesToStringAsString(
            pubMessage.payload.message);

        // Log para ver el mensaje recibido
        print('Mensaje recibido del tópico mpu6050: $message');

        // Manejo de mensaje vacío o incorrecto
        if (message.isNotEmpty) {
          final List<dynamic> decodedMessage = jsonDecode(message);

          if (decodedMessage.isNotEmpty && decodedMessage[0] != null) {
            final int pasos = decodedMessage[0]['pasos'] ?? 0;
            final int calorias = decodedMessage[0]['calorias'] ?? 0;
            final double distancia =
                decodedMessage[0]['distancia']?.toDouble() ?? 0.0;
            final int meta =
                decodedMessage[0]['meta'] ?? 300; // Agregar este campo

            print(
                'Pasos: $pasos, Calorías: $calorias, Distancia: $distancia, Meta: $meta');

            yield {
              'pasos': pasos,
              'calorias': calorias,
              'distancia': distancia,
              'meta': meta, // Incluir el campo meta en el yield
            };

            print(
                'Datos procesados: Pasos: $pasos, Calorías: $calorias, Distancia: $distancia km, Meta: $meta');
          } else {
            print('Mensaje vacío o con formato incorrecto: $message');
          }
        } else {
          print('Mensaje recibido vacío.');
        }
      }
    } else {
      print('No se pudo suscribir, estado: ${client.connectionStatus?.state}');
      client.disconnect();
    }
  }

  Stream<Map<String, dynamic>> obtenerInfoUsuarioStream() async* {
    await ensureConnected();

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe('relojVital/resultado/get/usuario', MqttQos.atMostOnce);

      final builder = MqttClientPayloadBuilder();
      client.publishMessage(
          'relojVital/get/usuario', MqttQos.atMostOnce, builder.payload!);

      await for (final c in client.updates!) {
        final pubMessage = c[0].payload as MqttPublishMessage;
        final String message = MqttPublishPayload.bytesToStringAsString(
            pubMessage.payload.message);

        final Map<String, dynamic> decodedMessage = jsonDecode(message);

        if (decodedMessage['registrado'] == true) {
          yield decodedMessage;
        } else {
          yield {'registrado': false};
        }

        print('Datos del usuario recibidos: $decodedMessage');
      }
    } else {
      print('No se pudo suscribir, estado: ${client.connectionStatus?.state}');
      client.disconnect();
    }
  }

  Stream<List<Map<String, dynamic>>>
      obtenerPromedioDiarioLatidosStream() async* {
    await ensureConnected();

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe('relojVital/respuesta/xd58c/diario', MqttQos.atMostOnce);

      final builder = MqttClientPayloadBuilder();
      client.publishMessage(
          'relojVital/get/xd58c/diario', MqttQos.atMostOnce, builder.payload!);

      await for (final c in client.updates!) {
        final pubMessage = c[0].payload as MqttPublishMessage;
        final String message = MqttPublishPayload.bytesToStringAsString(
            pubMessage.payload.message);

        final List<dynamic> decodedMessage = jsonDecode(message);
        final List<Map<String, dynamic>> latidos = decodedMessage.map((item) {
          return {
            'fecha': DateTime.parse(item['fecha']),
            'promedio': item['promedio'],
          };
        }).toList();

        yield latidos;
        print('Datos de promedio diario de latidos: $latidos');
      }
    } else {
      print('No se pudo suscribir, estado: ${client.connectionStatus?.state}');
      client.disconnect();
    }
  }

  Stream<List<Map<String, dynamic>>>
      obtenerPromedioDiarioCaloriasStream() async* {
    await ensureConnected();

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe(
          'relojVital/respuesta/mpu6050/diario', MqttQos.atMostOnce);

      final builder = MqttClientPayloadBuilder();
      client.publishMessage('relojVital/get/mpu6050/diario', MqttQos.atMostOnce,
          builder.payload!);

      await for (final c in client.updates!) {
        final pubMessage = c[0].payload as MqttPublishMessage;
        final String message = MqttPublishPayload.bytesToStringAsString(
            pubMessage.payload.message);

        final List<dynamic> decodedMessage = jsonDecode(message);
        final List<Map<String, dynamic>> calorias = decodedMessage.map((item) {
          return {
            'fecha': DateTime.parse(item['fecha']),
            'promedio': item['promedio'],
          };
        }).toList();

        yield calorias;
        print('Datos de promedio diario de calorias: $calorias');
      }
    } else {
      print('No se pudo suscribir, estado: ${client.connectionStatus?.state}');
      client.disconnect();
    }
  }

  void unsubscribeFromTopic(String topic) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.unsubscribe(topic);
      print('Desuscrito del tópico: $topic');
    } else {
      print(
          'No se pudo desuscribir, estado: ${client.connectionStatus?.state}');
    }
  }

  void unsubscribeAllExcept(List<String> topicsToKeep) {
    final allSubscriptions =
        client.subscriptionsManager?.subscriptions.keys.toList() ?? [];
    for (final topic in allSubscriptions) {
      if (!topicsToKeep.contains(topic)) {
        unsubscribeFromTopic(topic);
      }
    }
  }
}
