import 'package:flutter/material.dart';

final RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp passwordRegExp = RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$");
const String placeholderImage = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzfsTdRjF6giyFsO-d-Jw9beVB4cruN84U8n04eS3vZBHlgh2EFWe5KiTox-qt89I5-Io&usqp=CAU';

const Color darkTheme = Color.fromARGB(255, 19, 18, 18) ;
const Color lightTheme = Color.fromARGB(255, 255, 255, 255);
const Color borderLine = Color.fromARGB(255, 5, 164, 53);

enum PopupMenuOption{
  logout,
  profile
}

enum MessageType{
  text,
  image
}