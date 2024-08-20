import 'package:flutter/material.dart';
import 'package:instrumento/config/theme/app_theme.dart';
import 'package:instrumento/presentations/screens/appbar/appbar_screen.dart';
import 'package:instrumento/presentations/screens/footer/footer_screen.dart';
import 'package:fl_chart/fl_chart.dart'; // Librería para generar gráficas

class ActividadFisicaScreen extends StatefulWidget {
  const ActividadFisicaScreen({super.key});

  static const String name = 'ActividadFisicaScreen';

  @override
  __ActividadFisicaScreenState createState() => __ActividadFisicaScreenState();
}

class __ActividadFisicaScreenState extends State<ActividadFisicaScreen> {
  String selectedFilter = 'Día'; // Definimos la variable 'selectedFilter' aquí

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Actividad Física',
        userInfo: {
          'name': 'Saúl Reyes',
          'sex': 'Masculino',
          'height': '174 cm',
          'weight': '80 kg',
          'goal': '300 KCAL/DÍA',
        },
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
      mainAxisAlignment: MainAxisAlignment.center, // Centrar la fila completa
      crossAxisAlignment:
          CrossAxisAlignment.center, // Alineación vertical centrada
      children: [
        _buildPieChart(), // Gráfico circular
        const SizedBox(width: 40), // Espacio entre la gráfica y el texto
        const Column(
          crossAxisAlignment:
              CrossAxisAlignment.end, // Alinear el texto a la derecha
          children: [
            Text(
              'Objetivo',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black), // Texto en negro para contraste
            ),
            Text(
              '120/300 KCAL',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              'Pasos',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              '1,984',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              'Distancia',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text('1.34 KM',
                style: TextStyle(fontSize: 16, color: Colors.black)),
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
              value: 40,
              title: '40%',
              radius: 50,
              titleStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black), // Texto en negro para contraste
            ),
            PieChartSectionData(
              color: Colors.grey[300],
              value: 60,
              title: '60%',
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
