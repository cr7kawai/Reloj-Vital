import 'package:flutter/material.dart';
import 'package:instrumento/config/theme/app_theme.dart';
import 'package:instrumento/presentations/screens/appbar/appbar_screen.dart';
import 'package:instrumento/presentations/screens/footer/footer_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:instrumento/source/mqtt_service.dart'; // Librería para generar gráficas

class ActividadFisicaScreen extends StatefulWidget {
  const ActividadFisicaScreen({super.key});

  static const String name = 'ActividadFisicaScreen';

  @override
  __ActividadFisicaScreenState createState() => __ActividadFisicaScreenState();
}

class __ActividadFisicaScreenState extends State<ActividadFisicaScreen> {
  String selectedFilter = 'Día'; // Definimos la variable 'selectedFilter' aquí
  final MqttService _mqttService = MqttService('broker.emqx.io');
  int _pasos = 0;
  int _calorias = 0;
  double _distancia = 0.0;
  double _porcentajeCalorias = 0.0;
  int _metaCalorias = 300; // Valor por defecto de la meta de calorías

  @override
  void initState() {
    super.initState();

    // Escuchar los datos de la actividad física
    _mqttService.obtenerDatosActividadFisicaStream().listen((data) {
      print('Datos de actividad recibidos: $data');
      setState(() {
        _pasos = data['pasos'];
        _calorias = data['calorias'];
        _distancia = data['distancia'];
        _metaCalorias = data['meta']; // Actualizar la meta de calorías
        _porcentajeCalorias =
            (_calorias / _metaCalorias) * 100; // Usar la meta obtenida
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Actividad Física',
      ),
      body: Container(
        color: AppColors.lightPink
            .withOpacity(0.1), // Fondo rosa para toda la pantalla
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min, // Ajustar el tamaño del eje principal
          children: [
            const SizedBox(height: 20),
            _buildActivityOverview(), // Aquí se genera la sección superior
            const SizedBox(height: 20),
            _buildHistorySection(), // Añadimos la nueva sección de historial
          ],
        ),
      ),
      bottomNavigationBar: const CustomFooter(currentScreen: 'Actividad'),
      backgroundColor: AppColors.background,
    );
  }

  Widget _buildActivityOverview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildPieChart(), // Gráfico circular actualizado con el porcentaje de calorías
        const SizedBox(width: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Objetivo',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              '$_calorias/$_metaCalorias KCAL',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text(
              'Pasos',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              '$_pasos',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text(
              'Distancia',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text('$_distancia KM',
                style: const TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return Container(
      width: 100,
      height: 100,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: AppColors.softPink,
              value: _porcentajeCalorias,
              title: '${_porcentajeCalorias.toStringAsFixed(1)}%',
              radius: 50,
              titleStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            PieChartSectionData(
              color: Colors.grey[300],
              value: 100 - _porcentajeCalorias,
              title: '${(100 - _porcentajeCalorias).toStringAsFixed(1)}%',
              radius: 50,
              titleStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 20,
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightPink.withOpacity(0.1), // Fondo rosa claro
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Historial',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black), // Texto en negro para contraste
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
        _buildHistoryFilter('Mes', selectedFilter == 'Mes'),
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
    List<Widget> bars;

    if (selectedFilter == 'Día') {
      bars = [
        _buildHistoryBar('Lun', 50),
        _buildHistoryBar('Mar', 70),
        _buildHistoryBar('Miér', 90),
        _buildHistoryBar('Jue', 110),
        _buildHistoryBar('Vier', 100),
      ];
    } else if (selectedFilter == 'Semana') {
      bars = _buildWeeklyBars();
    } else if (selectedFilter == 'Mes') {
      bars = _buildMonthlyBars();
    } else {
      bars = [];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: bars,
    );
  }

  List<Widget> _buildWeeklyBars() {
    DateTime now = DateTime.now();
    int weeksInMonth = (now.day / 7).ceil();

    return List<Widget>.generate(weeksInMonth, (index) {
      return _buildHistoryBar('Sem ${index + 1}', 50.0 + (index * 20));
    });
  }

  List<Widget> _buildMonthlyBars() {
    List<String> months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];

    DateTime now = DateTime.now();

    return List<Widget>.generate(now.month, (index) {
      return _buildHistoryBar(months[index], 50.0 + (index * 10));
    });
  }

  Widget _buildHistoryBar(String label, double height) {
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
        Text(label,
            style: const TextStyle(
                color: Colors.black)), // Texto en negro para contraste
      ],
    );
  }
}
