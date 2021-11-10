import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final int _highscore;
  HomePage(this._highscore);
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 80
            ),
            child: Text(
              'S I L L Y S N A K E',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 45,
                fontFamily: 'Impact',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(30),
            child: Text(
              'High score: $_highscore',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
                fontFamily: 'Impact',
              ),
            ),
          ),
          Container(
            child: Image.asset(
              'assets/sprite/homepage.png',
              fit: BoxFit.contain,
            ),
            height: 250,
            width: 250,
          ),
          Container(
            child: Text(
              'Tap to start',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
                fontFamily: 'Impact',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
