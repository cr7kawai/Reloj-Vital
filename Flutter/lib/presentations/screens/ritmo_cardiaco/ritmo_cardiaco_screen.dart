import 'package:flutter/material.dart';
import 'package:instrumento/config/theme/app_theme.dart';
import 'package:instrumento/presentations/screens/appbar/appbar_screen.dart';
import 'package:instrumento/presentations/screens/footer/footer_screen.dart';

class RitmoCardiacoScreen extends StatelessWidget {
  const RitmoCardiacoScreen({super.key});

  static const String name = 'RitmoCardiacoScreen';

  @override
  Widget build(BuildContext context) {
    // Valor que indica la barra en la que se encuentra el usuario (Bajo, Normal, Alto)
    const int bpm = 70;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Ritmo Cardiaco',
        userInfo: {
          'name': 'Saúl Reyes',
          'sex': 'Masculino',
          'height': '174 cm',
          'weight': '80 kg',
          'goal': '300 KCAL/DÍA',
        },
      ),
      body: Stack(
        children: [
          Container(
            color: AppColors.lightPink
                .withOpacity(0.1), // Fondo rosa para toda la pantalla
          ),
          _HeartRateView(bpm: bpm), // Vista principal encima del fondo
        ],
      ),
      bottomNavigationBar: const CustomFooter(currentScreen: 'Ritmo'),
      backgroundColor: AppColors.background,
    );
  }
}

class _HeartRateView extends StatefulWidget {
  final int bpm;

  const _HeartRateView({required this.bpm});

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
              '${widget.bpm} BPM',
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

    // Cambia el color según el rango de bpm
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
        Text(label, style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}
