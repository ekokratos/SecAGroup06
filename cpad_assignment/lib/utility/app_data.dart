import 'dart:convert';

import 'package:cpad_assignment/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class AppData {
  static AppData? _singleton;
  static SharedPreferences? _prefs;
  static Lock _lock = Lock();

  static const String SP_USER = "SP_USER";
  static const String SP_ADMIN = "ADMIN";

  static Future<AppData?> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          // Keep the local instance until fully initialized.
          var singleton = AppData._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton;
  }

  AppData._();

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool>? setString(String key, String value) {
    if (_prefs == null) return null;
    return _prefs!.setString(key, value);
  }

  static String? getString(String key) {
    if (_prefs == null) return null;
    var status = _prefs!.getString(key);
    if (status == null) return "";
    return status;
  }

  static void saveUser(AppUser user) {
    if (_prefs != null) _prefs!.setString(SP_USER, json.encode(user.toMap()));
  }

  static AppUser? getUser() {
    if (_prefs == null) return null;
    String? userString = _prefs!.getString(SP_USER);
    if (userString == null) return null;
    return AppUser.fromMap(json.decode(userString));
  }

  static void setAdmin(bool isAdmin) {
    if (_prefs != null) _prefs!.setBool(SP_ADMIN, isAdmin);
  }

  static bool isAdmin() {
    if (_prefs == null) return false;
    return _prefs!.getBool(SP_ADMIN) ?? false;
  }

  static void clearSP() {
    if (_prefs != null) _prefs!.clear();
  }
}
