import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:instrumento/config/theme/app_theme.dart';

class RegistrarUsuarioScreen extends StatefulWidget {
  const RegistrarUsuarioScreen({super.key});

  static const String name = 'RegistrarUsuarioScreen';

  @override
  _RegistrarUsuarioScreenState createState() => _RegistrarUsuarioScreenState();
}

class _RegistrarUsuarioScreenState extends State<RegistrarUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();

  String nombre = '';
  String sexo = '';
  String estatura = '';
  String peso = '';
  String objetivo = '100 KCAL/DÍA';
  bool _isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: AppColors.lightPink,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {
                _isButtonDisabled = !_formKey.currentState!.validate();
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Perfil',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  'Nombre',
                  (value) => nombre = value,
                  'Por favor ingresa tu nombre',
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  'Sexo',
                  (value) => sexo = value,
                  'Por favor ingresa tu sexo',
                ),
                const SizedBox(height: 15),
                _buildNumberField(
                  'Estatura (cm)',
                  (value) => estatura = value,
                  'Por favor ingresa tu estatura',
                ),
                const SizedBox(height: 15),
                _buildNumberField(
                  'Peso (kg)',
                  (value) => peso = value,
                  'Por favor ingresa tu peso',
                ),
                const SizedBox(height: 25),
                const Text(
                  'Objetivo',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 15),
                _buildObjectiveDropdown(),
                const SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    width: 200, // Tamaño reducido del botón
                    child: ElevatedButton.icon(
                      onPressed: _isButtonDisabled ? null : _registrar,
                      icon: const Icon(
                        Icons.check,
                        size: 24, // Aumenta el tamaño del ícono
                        color: Colors.white, // Color blanco para resaltar
                      ),
                      label: const Text(
                        'Registrarme',
                        style: TextStyle(
                          color: Colors.white, // Color blanco para resaltar
                          fontSize: 16, // Aumenta el tamaño del texto
                          fontWeight:
                              FontWeight.bold, // Hacer el texto en negrita
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isButtonDisabled
                            ? AppColors.lightPink.withOpacity(0.5)
                            : AppColors.lightPink,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15), // Aumenta el padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30), // Botón con bordes más redondeados
                        ),
                        elevation: _isButtonDisabled
                            ? 0
                            : 5, // Añade elevación para más resalte cuando esté habilitado
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, Function(String) onSaved, String errorMessage) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onSaved: (value) => onSaved(value!),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
    );
  }

  Widget _buildNumberField(
      String label, Function(String) onSaved, String errorMessage) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onSaved: (value) => onSaved(value!),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
    );
  }

  Widget _buildObjectiveDropdown() {
    return DropdownButtonFormField<String>(
      value: objetivo,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      isExpanded: false, // Esto evitará que el menú abarque toda la pantalla
      items: const [
        DropdownMenuItem(
            value: '100 KCAL/DÍA', child: Center(child: Text('100 KCAL/DÍA'))),
        DropdownMenuItem(
            value: '200 KCAL/DÍA', child: Center(child: Text('200 KCAL/DÍA'))),
        DropdownMenuItem(
            value: '300 KCAL/DÍA', child: Center(child: Text('300 KCAL/DÍA'))),
      ],
      onChanged: (value) {
        setState(() {
          objetivo = value!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor selecciona un objetivo';
        }
        return null;
      },
    );
  }

  void _registrar() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Simulación del almacenamiento de los datos
      Navigator.pop(context, {
        'nombre': nombre,
        'sexo': sexo,
        'estatura': estatura,
        'peso': peso,
        'objetivo': objetivo,
      });
    }
  }
}
