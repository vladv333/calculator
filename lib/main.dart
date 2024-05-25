import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      home: CalculatorScreen(
        controller: CalculatorController(),
      ),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  final CalculatorController controller;

  CalculatorScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConverterScreen()),
              );
            },
            child: Text('Converter'),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CalculatorOutput(controller: controller),
                CalculatorButtonRow(
                  buttonTexts: ['7', '8', '9', '/'],
                  controller: controller,
                ),
                CalculatorButtonRow(
                  buttonTexts: ['4', '5', '6', 'x'],
                  controller: controller,
                ),
                CalculatorButtonRow(
                  buttonTexts: ['1', '2', '3', '-'],
                  controller: controller,
                ),
                CalculatorButtonRow(
                  buttonTexts: ['0', 'C', '=', '+'],
                  controller: controller,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConverterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Converter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConverterButton(
              conversionType: ConversionType.KilometerToMile,
            ),
            SizedBox(height: 20),
            ConverterButton(
              conversionType: ConversionType.MileToKilometer,
            ),
          ],
        ),
      ),
    );
  }
}

enum ConversionType { KilometerToMile, MileToKilometer }

class ConverterButton extends StatefulWidget {
  final ConversionType conversionType;

  ConverterButton({required this.conversionType});

  @override
  _ConverterButtonState createState() => _ConverterButtonState();
}

class _ConverterButtonState extends State<ConverterButton> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: widget.conversionType == ConversionType.KilometerToMile ? 'Kilometers' : 'Miles',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              double value = double.tryParse(_controller.text) ?? 0;
              double convertedValue = widget.conversionType == ConversionType.KilometerToMile ? value * 0.621371 : value / 0.621371;
              setState(() {
                _result = widget.conversionType == ConversionType.KilometerToMile
                    ? '$value kilometers = $convertedValue miles'
                    : '$value miles = $convertedValue kilometers';
              });
            },
            child: Text('Convert'),
          ),
          SizedBox(height: 20),
          Text(_result),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CalculatorOutput extends StatelessWidget {
  final CalculatorController controller;

  CalculatorOutput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.bottomRight,
        child: StreamBuilder<String>(
          stream: controller.output,
          builder: (context, snapshot) {
            return Text(
              snapshot.data ?? '',
              style: TextStyle(fontSize: 48.0),
            );
          },
        ),
      ),
    );
  }
}

class CalculatorButtonRow extends StatelessWidget {
  final List<String> buttonTexts;
  final CalculatorController controller;

  CalculatorButtonRow({required this.buttonTexts, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttonTexts
          .map((text) => CalculatorButton(
        text: text,
        onPressed: () {
          controller.onPressed(text);
        },
      ))
          .toList(),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CalculatorButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 24.0),
      ),
      color: Colors.grey[300],
      minWidth: 80.0,
      height: 80.0,
    );
  }
}

class CalculatorController {
  final CalculatorLogic _calculator = CalculatorLogic();
  final _outputController = StreamController<String>.broadcast();

  Stream<String> get output => _outputController.stream;

  void onPressed(String buttonText) {
    _outputController.add(_calculator.calculate(buttonText));
  }

  void dispose() {
    _outputController.close();
  }
}

class CalculatorLogic {
  String _output = '';
  double? _num1;
  double? _num2;
  String? _operand;

  String calculate(String buttonText) {
    if (buttonText == 'C') {
      _clear();
    } else if (buttonText == '=') {
      _calculate();
    } else if (buttonText == '+' ||
        buttonText == '-' ||
        buttonText == 'x' ||
        buttonText == '/') {
      _operand = buttonText;
      _output += buttonText;
    } else {
      _output += buttonText;
    }
    return _output;
  }

  void _clear() {
    _output = '';
    _num1 = null;
    _num2 = null;
    _operand = null;
  }

  void _calculate() {
    List<String> elements = _output.split(_operand!);
    if (elements.length == 2) {
      _num1 = double.tryParse(elements[0]);
      _num2 = double.tryParse(elements[1]);
      if (_num1 != null && _num2 != null) {
        switch (_operand) {
          case '+':
            _output = (_num1! + _num2!).toString();
            break;
          case '-':
            _output = (_num1! - _num2!).toString();
            break;
          case 'x':
            _output = (_num1! * _num2!).toString();
            break;
          case '/':
            if (_num2 != 0) {
              _output = (_num1! / _num2!).toString();
            } else {
              _output = 'Error';
            }
            break;
        }
      } else {
        _output = 'Error';
      }
    } else {
      _output = 'Error';
    }
  }
}
