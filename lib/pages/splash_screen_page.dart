import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            ),
          ),
        ),
        Center(
          child: Text(
            'Loading...',
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        )
      ]),
    );
  }
}
