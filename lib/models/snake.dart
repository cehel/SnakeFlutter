import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:snake/models/constants.dart';

class Snake extends StatelessWidget {
  final String choice;
  Snake(this.choice);

  Widget _getImage() {
    if (choice == 'head') {
      return Image.asset(
        'assets/sprite/schlangenkopf.png',
        fit: BoxFit.contain,
      );
    } else if (choice == 'tail') {
      return Image.asset(
        'assets/sprite/Schwanz.png',
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset(
        'assets/sprite/koerper.png',
        fit: BoxFit.contain,
      );
    }
  }

  Widget build(BuildContext context) {
    return Container(
      child: _getImage(),
      width: SNAKE_SIZE,
      height: SNAKE_SIZE,
    );
  }
}
