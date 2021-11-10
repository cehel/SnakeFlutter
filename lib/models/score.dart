import 'package:flutter/material.dart';
import 'package:snake/models/constants.dart';

Transform score(_score) {
  return Transform.translate(
    offset: Offset((GRID_X-2)*SNAKE_SIZE, 0),
    child: Container(
      padding: EdgeInsets.fromLTRB(0,10,GRID_X,0),
      child: Text(
        _score< 10 ? '0'+'$_score': '$_score',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Colors.white,
          fontFamily: 'Impact',
        ),
      ),
    ),
  );
}
