import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const String _keyFirstTime = 'isFirstTime';

  // Save onboarding seen status
  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstTime, false);
  }

  // Check if user is opening app first time
  static Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFirstTime) ?? true;
  }
}
