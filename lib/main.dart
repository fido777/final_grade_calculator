import 'package:flutter/material.dart';

void main() {
  runApp(const FinalGradeApp());
}

class FinalGradeApp extends StatelessWidget {
  const FinalGradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Nota Final',
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const FinalGradeCalculator(),
    );
  }
}

class FinalGradeCalculator extends StatefulWidget {
  const FinalGradeCalculator({super.key});

  @override
  State<FinalGradeCalculator> createState() => _FinalGradeCalculatorState();
}

class _FinalGradeCalculatorState extends State<FinalGradeCalculator> {
  // Controladores para los TextFields
  final _labController = TextEditingController();
  final _avance1Controller = TextEditingController();
  final _avance2Controller = TextEditingController();
  final _proyectoFinalController = TextEditingController();

  // Definimos FocusNodes para manejar el foco entre TextFormFields
  final _labFocus = FocusNode();
  final _avance1Focus = FocusNode();
  final _avance2Focus = FocusNode();
  final _proyectoFinalFocus = FocusNode();

  // Variables para el manejo de errores, indiqcan que las entradas son válidas
  bool _labOk = false;
  bool _avance1Ok = false;
  bool _avance2Ok = false;
  bool _proyectoFinalOk = false;

  // Variable para la nota final
  double? _finalGrade;

  // Validar que el input sea un número entre 0 y 5, y que es un número
  bool _validateInput(String value) {
    // double.tryParse intenta convertir un string a un double. Si falla, retorna null, NaN u otros, pero no arroja error
    final double? number = double.tryParse(value);
    return number != null && number >= 0 && number <= 5;
  }

  // Método para calcular la nota final
  void _calculateFinalGrade() {
    setState(() {
      _labOk = _validateInput(_labController.text);
      _avance1Ok = _validateInput(_avance1Controller.text);
      _avance2Ok = _validateInput(_avance2Controller.text);
      _proyectoFinalOk = _validateInput(_proyectoFinalController.text);

      if (_labOk && _avance1Ok && _avance2Ok && _proyectoFinalOk) {
        final double labGrade = double.parse(_labController.text);
        final double avance1Grade = double.parse(_avance1Controller.text);
        final double avance2Grade = double.parse(_avance2Controller.text);
        final double proyectoFinalGrade =
            double.parse(_proyectoFinalController.text);

        // Fórmula: 60% prácticas, 10% avance 1, 10% avance 2, 20% proyecto final
        _finalGrade = (labGrade * 0.6) +
            (avance1Grade * 0.1) +
            (avance2Grade * 0.1) +
            (proyectoFinalGrade * 0.2);
      } else {
        _finalGrade = null; // Si hay errores, no calculamos la nota final
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final TextStyle winStyle = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.primary);

    final TextStyle loseStyle =
        theme.textTheme.titleMedium!.copyWith(color: const Color.fromARGB(255, 150, 54, 16));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Nota Final'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TextField para la nota de prácticas de laboratorio
            _buildTextField(
                controller: _labController,
                labelText: 'Nota Prácticas de Laboratorio (60%)',
                errorText:
                    !_labOk ? 'Debe ingresar sólo números entre 0 y 5' : null,
                focusNode: _labFocus,
                nextFocusNode: _avance1Focus),
            const SizedBox(height: 16),

            // TextField para la nota del primer avance
            _buildTextField(
                controller: _avance1Controller,
                labelText: 'Primer Avance del Proyecto (10%)',
                errorText: !_avance1Ok
                    ? 'Debe ingresar sólo números entre 0 y 5'
                    : null,
                focusNode: _avance1Focus,
                nextFocusNode: _avance2Focus),
            const SizedBox(height: 16),

            // TextField para la nota del segundo avance
            _buildTextField(
                controller: _avance2Controller,
                labelText: 'Segundo Avance del Proyecto (10%)',
                errorText: !_avance2Ok
                    ? 'Debe ingresar sólo números entre 0 y 5'
                    : null,
                focusNode: _avance2Focus,
                nextFocusNode: _proyectoFinalFocus),
            const SizedBox(height: 16),

            // TextField para la nota de la entrega del proyecto final
            _buildTextField(
              controller: _proyectoFinalController,
              labelText: 'Entrega del Proyecto Final (20%)',
              errorText: !_proyectoFinalOk
                  ? 'Debe ingresar sólo números entre 0 y 5'
                  : null,
              focusNode: _proyectoFinalFocus,
              // No se le ingresa referencia al siguiente text field porque es el último text field
            ),
            const SizedBox(height: 32),

            // Mostrar el resultado de la nota final
            if (_finalGrade != null)
              Text(
                'Nota Final: ${_finalGrade!.toStringAsFixed(2)}',
                style: _finalGrade! >= 3.0 ? winStyle : loseStyle,
                textAlign: TextAlign.center,
              )
          ],
        ),
      ),
    );
  }

  // Método para construir cada TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? errorText,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      // Si el siguiente focus es nulo, usar done
      textInputAction:
          nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue), // Borde azul al enfocar
        ),
      ),
      onChanged: (value) {
        _calculateFinalGrade(); // Se calcula automáticamente al cambiar el valor
      },
      onFieldSubmitted: (value) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
    );
  }

  @override
  void dispose() {
    _labController.dispose();
    _avance1Controller.dispose();
    _avance2Controller.dispose();
    _proyectoFinalController.dispose();
    _labFocus.dispose();
    _avance1Focus.dispose();
    _avance2Focus.dispose();
    _proyectoFinalFocus.dispose();
    super.dispose();
  }
}
