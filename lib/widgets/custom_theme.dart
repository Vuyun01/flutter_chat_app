import 'package:flutter/material.dart';

ThemeData CustomTheme(BuildContext context) {
  return ThemeData(
      // scaffoldBackgroundColor: Color.fromARGB(255, 208, 233, 240),
      colorScheme: const ColorScheme.light(
          primary: Colors.teal, secondary: Colors.white, tertiary: Colors.black87),
      textTheme: const TextTheme(
        bodyText1: TextStyle(color: Colors.black87, fontSize: 16),
        bodyText2: TextStyle(color: Colors.black54, fontSize: 14),
        headline3: TextStyle(
            color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        headline1: TextStyle(
            color: Colors.black87, fontSize: 25, fontWeight: FontWeight.bold),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
            //shape for its children
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.teal)),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        backgroundColor: Colors.teal.shade300,
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.teal),
            borderRadius: BorderRadius.circular(10)),
      )),
      inputDecorationTheme: CustomInputDecoration());
}

InputDecorationTheme CustomInputDecoration({Color color = Colors.teal}) {
  return InputDecorationTheme(
    floatingLabelStyle: TextStyle(color: color),
    contentPadding: const EdgeInsets.fromLTRB(20, 30, 0, 20),
    prefixIconColor: color,
    border: CustomOutlineInputBorder(),
    focusedBorder: CustomOutlineInputBorder(),
  );
}

OutlineInputBorder CustomOutlineInputBorder(
    {double width = 1, Color color = Colors.teal}) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      gapPadding: 10,
      borderSide: BorderSide(width: width, color: color));
}
