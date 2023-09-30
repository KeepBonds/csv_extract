import 'package:shared_preferences/shared_preferences.dart';

class StorageKey {
  static const ROW_WIDTH = 'ROW_WIDTH';
  static const ROW_HEIGHT = 'ROW_HEIGHT';
  static const HEADER_STYLE_BOLD = 'HEADER_STYLE_BOLD';
  static const HEADER_STYLE_ITALIC = 'HEADER_STYLE_ITALIC';
  static const HEADER_FONT_SIZE = 'HEADER_FONT_SIZE';

  static const VALUE_STYLE_BOLD = 'VALUE_STYLE_BOLD';
  static const VALUE_STYLE_ITALIC = 'VALUE_STYLE_ITALIC';
  static const VALUE_FONT_SIZE = 'VALUE_FONT_SIZE';

  static const SHOW_X = 'SHOW_X';
  static const SHOW_DATA = 'SHOW_DATA';
  static const SHOW_95 = 'SHOW_95';

  static const STANDARD_DEVIATION_THRESHOLD = 'STANDARD_DEVIATION_THRESHOLD';
  static const STANDARD_DEVIATION_LAYOUT = 'STANDARD_DEVIATION_LAYOUT';

  static const COLOR_TEMPLATE = 'COLOR_TEMPLATE';

  static const GRAPH_LINE_WIDTH = 'GRAPH_LINE_WIDTH';

  static const HISTORY_DATA = 'HISTORY_DATA';
}

class CacheManager {
  static Future<String> getString(String key) async {
    return await SharedPreferences.getInstance().then((instance) {
      return instance.getString(key) ?? "";
    });
  }

  static Future<void> setString(String key, String value) async {
    await SharedPreferences.getInstance().then((instance) async {
      await instance.setString(key, value);
    });
  }

  static Future<int?> getInt(String key, {int? defaultValue}) async {
    return await SharedPreferences.getInstance().then((instance) {
      return instance.getInt(key) ?? defaultValue ?? 0;
    });
  }

  static Future<void> setInt(String key, int value) async {
    await SharedPreferences.getInstance().then((instance) async {
      await instance.setInt(key, value);
    });
  }

  static Future<double?> getDouble(String key, {double? defaultValue}) async {
    return await SharedPreferences.getInstance().then((instance) {
      return instance.getDouble(key) ?? defaultValue ?? 0.0;
    });
  }

  static Future<void> setDouble(String key, double value) async {
    await SharedPreferences.getInstance().then((instance) async {
      await instance.setDouble(key, value);
    });
  }

  static Future<bool?> getBool(String key) async {
    return await SharedPreferences.getInstance().then((instance) {
      return instance.getBool(key);
    });
  }

  static Future<void> setBool(String key, bool value) async {
    await SharedPreferences.getInstance().then((instance) async {
      await instance.setBool(key, value);
    });
  }

  static Future<void> removeByKey(String key) async {
    await SharedPreferences.getInstance().then((instance) async {
      await instance.remove(key);
    });
  }
}