import 'package:new_nuntium/core/constants/constanst.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPrefs {
  AppSharedPrefs(this._preferences);

  final SharedPreferences _preferences;

  String? get locale => _preferences.getString(SharedPrefsKeys.locale);

  Future<void> setLocale(String locale) async {
    await _preferences.setString(SharedPrefsKeys.locale, locale);
  }
}
