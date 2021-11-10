import 'package:flutter/material.dart';
import 'package:snake/models/constants.dart';

class Apple extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        'assets/sprite/RotApfel.png',
        fit: BoxFit.contain,
      ),
      width: APPLE_SIZE,
      height: APPLE_SIZE,
    );
  }
}
