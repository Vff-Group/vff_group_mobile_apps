import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtils {
  static save_val(String key, String value) {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((SharedPreferences prefs) {
      return prefs.setString(key, value);
    });
  }

  static saveList_val(String key, List<String> value) {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((SharedPreferences prefs) {
      return prefs.setStringList(key, value);
    });
  }

  static get_val(String key) {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((SharedPreferences prefs) {
      return prefs.getString(key);
    });
  }

  static getList_val(String key) {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList(key);
    });
  }

}
