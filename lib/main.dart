import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.0),
              alignment: Alignment.bottomRight,
              child: Text(
                '0',
                style: TextStyle(fontSize: 48.0),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildButton('7'),
              buildButton('8'),
              buildButton('9'),
              buildButton('/'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildButton('4'),
              buildButton('5'),
              buildButton('6'),
              buildButton('x'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildButton('1'),
              buildButton('2'),
              buildButton('3'),
              buildButton('-'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildButton('0'),
              buildButton('C'),
              buildButton('='),
              buildButton('+'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(String text) {
    return MaterialButton(
      onPressed: () {},
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
