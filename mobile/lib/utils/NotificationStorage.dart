

import 'package:shared_preferences/shared_preferences.dart';


class NotificationStorage {


  static Future<bool> isEnabled() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool("notifications") ?? true;

  }



  static Future<void> setEnabled(bool value) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
        "notifications",
        value
    );

  }


}