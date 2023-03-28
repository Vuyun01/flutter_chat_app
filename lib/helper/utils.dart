import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Future<void> storeUserDataToDevice(
      {required String key, required String userId}) async {
    final userInfo =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userInfo.exists) {
      final user = {
        'firstName': userInfo['firstName'],
        'lastName': userInfo['lastName'],
        'email': userInfo['email'],
        'password': userInfo['password'],
        'imageURL': userInfo['imageURL'],
      };
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(key, json.encode(user));
    }
  }

  static Future<Map<String, dynamic>> getUserDataFromDevice(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.decode(prefs.getString(key)!) as Map<String, dynamic>;
    return data;
  }
}
