import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _mode;
  ThemeMode get mode => _mode;
  ThemeProvider({
    ThemeMode mode = ThemeMode.light,
  }) : _mode = mode;

  void toggleTheme() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Color.fromARGB(255, 220, 220, 220),
    primaryColor: Color.fromARGB(255, 80, 197, 78),
    //colorScheme: const ColorScheme.light(),
    primarySwatch: Colors.grey,
    backgroundColor: Color(0xffF1F5FB),
    indicatorColor: Color(0xffCBDCF8),
    hintColor: Color.fromARGB(255, 79, 169, 37),
    highlightColor: Color(0xffFCE192),
    hoverColor: Color(0xff4285F4),
    focusColor: Color(0xffA8DAB5),
    disabledColor: Colors.grey,
    cardColor: Colors.white,
    canvasColor: Colors.grey[50],
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Color.fromRGBO(36, 36, 36, 1),
    //colorScheme: const ColorScheme.dark(),
    primarySwatch: Colors.grey,
    backgroundColor: Colors.black,
    indicatorColor: Color(0xff0E1D36),
    buttonColor: Color(0xff3B3B3B),
    hintColor: Color(0xff280C0B),
    highlightColor: Color(0xff372901),
    hoverColor: Color(0xff3A3A3B),
    focusColor: Color(0xff0B2512),
    disabledColor: Colors.grey,
    textSelectionColor: Colors.white,
    cardColor: Color(0xFF151515),
    canvasColor: Colors.black,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
    ),
  );
}
