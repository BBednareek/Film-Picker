import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static const String keyUserID = 'KEY_USER_ID';

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(keyUserID);
    if (userId == null) {
      throw Exception('User ID not available.');
    }
    return userId;
  }

  static Future<void> setUserId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserID, id);
  }

  static Future<void> removeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUserID);
  }
}
