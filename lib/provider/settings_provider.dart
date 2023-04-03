import 'package:flutter/cupertino.dart';

class SettingsProvider with ChangeNotifier{
  bool isDark = false;
  void changeBackgroundColor(bool value){
    isDark = value;
    notifyListeners();
  }
}