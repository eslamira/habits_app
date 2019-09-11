import 'package:flutter/material.dart';

class AppTheme {
  final Color mainColor;
  ThemeData appTheme;

  AppTheme(this.mainColor) {
    appTheme = ThemeData(
      primaryColor: mainColor,
      textTheme: TextTheme(
        title: TextStyle(
          fontSize: 24.0,
          color: Colors.black,
          fontWeight: FontWeight.w800,
        ),
        subtitle: TextStyle(
          fontSize: 18.0,
          color: mainColor,
          fontWeight: FontWeight.w600,
        ),
        display1: TextStyle(
          fontSize: 16.0,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
        display2: TextStyle(
          fontSize: 18.0,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        color: mainColor,
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
