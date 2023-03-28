import 'package:flutter/cupertino.dart';

class ColorScreenTheme with ChangeNotifier{
  bool isDark = false;
  void changeBackgroundColor(bool value){
    isDark = value;
    notifyListeners();
  }
}