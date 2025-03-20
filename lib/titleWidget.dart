import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class titlewidget extends StatelessWidget {
  String text;
  Color color;

  titlewidget({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        color: color,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
