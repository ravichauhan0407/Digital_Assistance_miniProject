import 'package:shared_preferences/shared_preferences.dart';

class Sharedpref {
  static String nameSharedPreference = "name";
  static String citySharedPreference = "city";
  static String stateSharedPreference = "state";
  static String locationSharedPreference = "Enter Location";

  static Future<bool> saveUserNamePreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(nameSharedPreference, userName);
  }

  static Future<String> getUserNamePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(nameSharedPreference);
  }

  static Future<bool> saveCityPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(citySharedPreference, userName);
  }

  static Future<String> getCityPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(citySharedPreference);
  }

  static Future<bool> saveStatePreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(stateSharedPreference, userName);
  }

  static Future<String> getStatePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(stateSharedPreference);
  }

  static Future<bool> saveLocationPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(locationSharedPreference, userName);
  }

  static Future<String> getLocationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(locationSharedPreference);
  }
}
