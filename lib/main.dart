import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({super.key});

  @override
  State<SimpleCalculator> createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = "0";
  String results = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        equation = "0";
        results = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      } else if (buttonText == 'Del') {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == '=') {
        equationFontSize = 38.0;
        resultFontSize = 48.0;

        //
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        // solve
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          results = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          results = 'Error';
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesabu'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              equation,
              style: const TextStyle(fontSize: 38),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              results,
              style: const TextStyle(fontSize: 48),
            ),
          ),
          const Expanded(child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton('C', 1, Colors.redAccent),
                      buildButton('Del', 1, Colors.blue),
                      buildButton('÷', 1, Colors.blue)
                    ]),
                    TableRow(children: [
                      buildButton('7', 1, Colors.black45),
                      buildButton('8', 1, Colors.black45),
                      buildButton('9', 1, Colors.black45)
                    ]),
                    TableRow(children: [
                      buildButton('4', 1, Colors.black45),
                      buildButton('5', 1, Colors.black45),
                      buildButton('6', 1, Colors.black45)
                    ]),
                    TableRow(children: [
                      buildButton('1', 1, Colors.black45),
                      buildButton('2', 1, Colors.black45),
                      buildButton('3', 1, Colors.black45)
                    ]),
                    TableRow(children: [
                      buildButton('.', 1, Colors.black45),
                      buildButton('0', 1, Colors.black45),
                      buildButton('00', 1, Colors.black45)
                    ]),
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Table(children: [
                    TableRow(children: [
                      buildButton('×', 1, Colors.blue),
                    ]),
                    TableRow(children: [
                      buildButton('-', 1, Colors.blue),
                    ]),
                    TableRow(children: [
                      buildButton('+', 1, Colors.blue),
                    ]),
                    TableRow(children: [
                      buildButton('=', 2, Colors.redAccent),
                    ]),
                  ]))
            ],
          )
        ],
      ),
    );
  }

  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            side: const BorderSide(
                color: Colors.white, width: 1, style: BorderStyle.solid)),
        // ignore: sort_child_properties_last
        child: Text(
          buttonText,
          style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () => buttonPressed(buttonText),
      ),
    );
  }
}
