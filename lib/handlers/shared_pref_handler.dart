import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> addName(String name) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    return name;
  } catch (e) {
    return '';
  }
}

Future<String?> getName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('name');
}

Future<bool> deleteName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.remove('name');
}

Future<String?> addEmail(String email) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    return email;
  } catch (e) {
    return null;
  }
}

Future<String?> getEmail() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

Future<bool> deleteEmail() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.remove('email');
}

Future<String?> addPicture(String picture) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('picture', picture);
    return picture;
  } catch (e) {
    return null;
  }
}

Future<String?> getPicture() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('picture');
}

Future<bool> deletePicture() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.remove('picture');
}

Future<bool> addIsLoggedIn(bool isLoggedIn) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
    return isLoggedIn;
  } catch (e) {
    return false;
  }
}

Future<bool?> getIsLoggedIn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn');
}
