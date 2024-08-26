import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear las fechas
import 'package:instrumento/config/theme/app_theme.dart';
import 'package:instrumento/presentations/screens/appbar/appbar_screen.dart';
import 'package:instrumento/presentations/screens/footer/footer_screen.dart';
import 'package:instrumento/source/mqtt_service.dart';

class RitmoCardiacoScreen extends StatefulWidget {
  const RitmoCardiacoScreen({super.key});

  static const String name = 'RitmoCardiacoScreen';

  @override
  _RitmoCardiacoScreenState createState() => _RitmoCardiacoScreenState();
}

class _RitmoCardiacoScreenState extends State<RitmoCardiacoScreen> {
  late MqttService _mqttService;
  double _bpm = 70; // Valor inicial del bpm
  List<Map<String, dynamic>> _historialLatidos = []; // Historial de latidos

  @override
  void initState() {
    super.initState();
    _mqttService = MqttService('broker.emqx.io');

    // Suscribir a los tópicos necesarios para esta pantalla
    _mqttService.ensureConnected().then((_) {
      _mqttService.unsubscribeAllExcept([
        'relojVital/resultado/post/xd58c', // Tópico para frecuencia cardíaca
        'relojVital/respuesta/xd58c/diario', // Tópico para el historial de latidos diarios
      ]);

      _mqttService.obtenerFrecuenciaCardiacaStream().listen((value) {
        setState(() {
          _bpm = value;
        });
      });

      _mqttService.obtenerPromedioDiarioLatidosStream().listen((data) {
        setState(() {
          _historialLatidos = data;
        });
      });
    });
  }

  @override
  void dispose() {
    _mqttService.unsubscribeAllExcept([]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Ritmo Cardiaco',
      ),
      body: Stack(
        children: [
          Container(
            color: AppColors.lightPink.withOpacity(0.1),
          ),
          _HeartRateView(bpm: _bpm, historialLatidos: _historialLatidos),
        ],
      ),
      bottomNavigationBar: const CustomFooter(currentScreen: 'Ritmo'),
      backgroundColor: AppColors.background,
    );
  }
}

class _HeartRateView extends StatefulWidget {
  final double bpm;
  final List<Map<String, dynamic>> historialLatidos;

  const _HeartRateView({
    required this.bpm,
    required this.historialLatidos,
  });

  @override
  __HeartRateViewState createState() => __HeartRateViewState();
}

class __HeartRateViewState extends State<_HeartRateView> {
  String selectedFilter = 'Día';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          Center(
            child: Text(
              '${widget.bpm.toStringAsFixed(1)} BPM',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildHeartRateIndicator(),
          const SizedBox(height: 10),
          _buildHistorySection(),
        ],
      ),
    );
  }

  Widget _buildHeartRateIndicator() {
    Color lowColor = AppColors.lightPink.withOpacity(0.3);
    Color normalColor = AppColors.lightPink.withOpacity(0.3);
    Color highColor = AppColors.lightPink.withOpacity(0.3);

    if (widget.bpm < 60) {
      lowColor = AppColors.softPink;
    } else if (widget.bpm >= 60 && widget.bpm <= 100) {
      normalColor = AppColors.softPink;
    } else if (widget.bpm > 100) {
      highColor = AppColors.softPink;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildHeartRateLevel('Bajo', lowColor),
          ),
          Expanded(
            child: _buildHeartRateLevel('Normal', normalColor),
          ),
          Expanded(
            child: _buildHeartRateLevel('Alto', highColor),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartRateLevel(String label, Color color) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 20,
          color: color,
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.black)),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightPink.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Historial',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 10),
            _buildHistoryFilters(),
            const SizedBox(height: 10),
            Expanded(child: _buildHistoryChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHistoryFilter('Día', selectedFilter == 'Día'),
        _buildHistoryFilter('Semana', selectedFilter == 'Semana'),
      ],
    );
  }

  Widget _buildHistoryFilter(String label, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: selected ? AppColors.softPink : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.softPink),
        ),
        child: Text(
          label,
          style: TextStyle(color: selected ? Colors.white : AppColors.softPink),
        ),
      ),
    );
  }

  Widget _buildHistoryChart() {
    if (selectedFilter == 'Día') {
      return _buildDailyChart();
    } else if (selectedFilter == 'Semana') {
      return _buildWeeklyChart();
    } else {
      return Container();
    }
  }

  Widget _buildDailyChart() {
    List<Widget> bars = [];
    final lastFiveDays = getLastFiveDays();
    double maxPromedio = widget.historialLatidos.isNotEmpty
        ? widget.historialLatidos
            .map((data) => (data['promedio'] as num).toDouble())
            .reduce((a, b) => a > b ? a : b)
        : 1.0;

    for (int i = 0; i < lastFiveDays.length; i++) {
      double promedio = widget.historialLatidos.isNotEmpty &&
              i < widget.historialLatidos.length
          ? (widget.historialLatidos[i]['promedio'] as num).toDouble()
          : 0.0;

      double barHeight = promedio / maxPromedio * 100;
      bars.add(_buildHistoryBar(lastFiveDays[i], barHeight, promedio));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: bars,
    );
  }

  Widget _buildWeeklyChart() {
    List<Widget> bars = [];
    final weeksData = getWeeksData();
    double maxPromedio = weeksData.isNotEmpty
        ? weeksData
            .map((data) => data['promedio'] as double)
            .reduce((a, b) => a > b ? a : b)
        : 1.0;

    for (var week in weeksData) {
      double promedio = week['promedio'];
      double barHeight = promedio / maxPromedio * 100;
      bars.add(_buildHistoryBar(week['semana'], barHeight, promedio));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: bars,
    );
  }

  Widget _buildPlaceholderChart() {
    return Center(child: Text('No hay datos para mostrar.'));
  }

  Widget _buildHistoryBar(String label, double height, double promedio) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 5),
        Text('${promedio.toStringAsFixed(1)}',
            style: const TextStyle(color: Colors.black)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.black)),
      ],
    );
  }

  List<String> getLastFiveDays() {
    final DateFormat formatter = DateFormat('EEE', 'es_ES');
    final now = DateTime.now();
    return List.generate(5,
        (index) => formatter.format(now.subtract(Duration(days: 4 - index))));
  }

  List<Map<String, dynamic>> getWeeksData() {
    Map<int, List<double>> semanas = {};
    for (var entry in widget.historialLatidos) {
      DateTime fecha = entry['fecha'];
      int weekOfMonth = (fecha.day - 1) ~/ 7 + 1;

      if (!semanas.containsKey(weekOfMonth)) {
        semanas[weekOfMonth] = [];
      }
      semanas[weekOfMonth]!.add((entry['promedio'] as num).toDouble());
    }

    List<Map<String, dynamic>> result = [];
    semanas.forEach((week, valores) {
      double promedio = valores.reduce((a, b) => a + b) / valores.length;
      result.add({
        'semana': 'Sem $week',
        'promedio': promedio,
      });
    });

    return result;
  }
}
