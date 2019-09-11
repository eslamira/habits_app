import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habits_app/ui/main_screen.dart';
import 'package:habits_app/utils/app_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static void setTheme(BuildContext context, Color newColor) {
    _MyAppState state = context.ancestorStateOfType(TypeMatcher<_MyAppState>());

    // ignore: invalid_use_of_protected_member
    state.setState(() {
      state._color = newColor;
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(systemNavigationBarColor: state._color));
    });
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _color;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habits App',
      theme: AppTheme(_color ?? Colors.blue).appTheme,
      home: MainScreen(),
    );
  }
}
