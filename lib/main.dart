import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});
  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _expression = '';
  String _result = '';

  void numClick(String text) {
    setState(() {
      // prevent multiple leading zeros like '00'
      if (_expression == '0' && text == '0') return;
      if (_expression == '0' && text != '.') {
        _expression = text;
      } else {
        _expression += text;
      }
    });
  }

  void allClear() {
    setState(() {
      _expression = '';
      _result = '';
    });
  }

  void deleteLast() {
    setState(() {
      if (_expression.isNotEmpty) _expression = _expression.substring(0, _expression.length - 1);
    });
  }

  bool _isOperator(String s) {
    return s == '+' || s == '-' || s == '×' || s == '÷' || s == '*' || s == '/';
  }

  void operatorClick(String op) {
    setState(() {
      if (_expression.isEmpty && op == '-') {
        // allow negative number at start
        _expression = '-';
        return;
      }
      if (_expression.isEmpty) return;
      String last = _expression[_expression.length - 1];
      if (_isOperator(last)) {
        // replace last operator with new one
        _expression = _expression.substring(0, _expression.length - 1) + op;
      } else {
        _expression += op;
      }
    });
  }

  String _formatResult(num value) {
    // remove trailing .0 for whole numbers
    if (value == value.round()) return value.toStringAsFixed(0);
    return value.toString();
  }

  void calculateResult() {
    try {
      String exp = _expression.replaceAll('×', '*').replaceAll('÷', '/');
      // Basic safe evaluation: tokenise and compute using shunting-yard or simple parser.
      // For brevity we'll use a simple expression evaluator supporting + - * / and parentheses.
      num res = _evalExpression(exp);
      setState(() {
        _result = _formatResult(res);
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  // --- Simple expression evaluator ---
  // Supports + - * / and parentheses. No functions, no variables.
  num _evalExpression(String expr) {
    final tokens = _tokenize(expr);
    final rpn = _toRPN(tokens);
    return _evalRPN(rpn);
  }

  List<String> _tokenize(String s) {
    List<String> out = [];
    int i = 0;
    while (i < s.length) {
      final ch = s[i];
      if (ch == ' ') { i++; continue; }
      if (RegExp(r'[0-9.]').hasMatch(ch)) {
        String num = ch;
        i++;
        while (i < s.length && RegExp(r'[0-9.]').hasMatch(s[i])) {
          num += s[i]; i++;
        }
        out.add(num);
        continue;
      }
      if (_isOperator(ch) || ch == '(' || ch == ')') {
        out.add(ch);
        i++;
        continue;
      }
      // unknown char - skip
      i++;
    }
    return out;
  }

  int _prec(String op) {
    if (op == '+' || op == '-') return 1;
    if (op == '*' || op == '/') return 2;
    return 0;
  }

  List<String> _toRPN(List<String> tokens) {
    List<String> output = [];
    List<String> stack = [];
    for (final token in tokens) {
      if (RegExp(r'^[0-9.]+$').hasMatch(token)) {
        output.add(token);
      } else if (_isOperator(token)) {
        while (stack.isNotEmpty && _isOperator(stack.last) &&
            _prec(stack.last) >= _prec(token)) {
          output.add(stack.removeLast());
        }
        stack.add(token);
      } else if (token == '(') {
        stack.add(token);
      } else if (token == ')') {
        while (stack.isNotEmpty && stack.last != '(') {
          output.add(stack.removeLast());
        }
        if (stack.isNotEmpty && stack.last == '(') stack.removeLast();
      }
    }
    while (stack.isNotEmpty) output.add(stack.removeLast());
    return output;
  }

  num _evalRPN(List<String> rpn) {
    List<num> stack = [];
    for (final token in rpn) {
      if (RegExp(r'^[0-9.]+$').hasMatch(token)) {
        stack.add(num.parse(token));
      } else if (_isOperator(token)) {
        if (stack.length < 2) throw Exception('Invalid expression');
        final b = stack.removeLast();
        final a = stack.removeLast();
        num res;
        switch (token) {
          case '+': res = a + b; break;
          case '-': res = a - b; break;
          case '*': res = a * b; break;
          case '/': res = a / b; break;
          default: throw Exception('Unknown op');
        }
        stack.add(res);
      } else {
        throw Exception('Invalid token $token');
      }
    }
    if (stack.length != 1) throw Exception('Invalid evaluation');
    return stack.first;
  }

  Widget buildButton(String text, {double flex = 1, Color? color, void Function()? onTap}) {
    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          onPressed: onTap ?? () {
            if (RegExp(r'^[0-9.]$').hasMatch(text)) numClick(text);
            else if (text == 'C') allClear();
            else if (text == '⌫') deleteLast();
            else if (text == '=') calculateResult();
            else if (text == '+' || text == '-' || text == '×' || text == '÷' || text == '*' || text == '/') operatorClick(text);
            else {}
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: color,
          ),
          child: Text(text, style: const TextStyle(fontSize: 22)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Calculator')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_expression, style: const TextStyle(fontSize: 28, color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text(_result, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Container(height: 1, color: Colors.grey[300]),
            Column(
              children: [
                Row(
                  children: [
                    buildButton('C', onTap: allClear),
                    buildButton('⌫', onTap: deleteLast),
                    buildButton('%', onTap: () {
                      setState(() {
                        try {
                          if (_expression.isNotEmpty && !_isOperator(_expression[_expression.length-1])) {
                            num v = num.parse(_expression);
                            _expression = (v/100).toString();
                          }
                        } catch (e) {}
                      });
                    }),
                    buildButton('÷', onTap: () => operatorClick('÷')),
                  ],
                ),
                Row(
                  children: [
                    buildButton('7'),
                    buildButton('8'),
                    buildButton('9'),
                    buildButton('×', onTap: () => operatorClick('×')),
                  ],
                ),
                Row(
                  children: [
                    buildButton('4'),
                    buildButton('5'),
                    buildButton('6'),
                    buildButton('-', onTap: () => operatorClick('-')),
                  ],
                ),
                Row(
                  children: [
                    buildButton('1'),
                    buildButton('2'),
                    buildButton('3'),
                    buildButton('+', onTap: () => operatorClick('+')),
                  ],
                ),
                Row(
                  children: [
                    buildButton('0', flex: 2),
                    buildButton('.'),
                    buildButton('=', onTap: calculateResult),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}