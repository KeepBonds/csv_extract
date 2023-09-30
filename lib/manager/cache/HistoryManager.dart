import 'dart:convert';
import '../../object/object.dart';
import '../manager.dart';

class HistoryManager {
  static List<HistoryItem> loadedItems = [];

  static List<HistoryItem> historyItems = [];

  static Future<void> saveItem(DirectoryData data, String path) async {
    List<BandsAverage> avgs = DirectoryExtractManager.dirBands[data.directory] ?? [];

    HistoryItem historyItem = HistoryItem(
        originFolder: data.directory.toString(),
        img: path,
        data: avgs,
    );

    await saveInCache(historyItem); // Save the updated list to cache.
  }

  static Future<void> saveInCache(HistoryItem item) async {
    historyItems.add(item);
    await saveToCache(); // Save the updated list to cache.
  }

  // If you want to save and load the historyItems from JSON, you can use these methods:

  static Future<void> saveToCache() async {
    final List<Map<String, dynamic>> historyListJson = historyItems.map((item) => item.toJson()).toList();
    await CacheManager.setString(StorageKey.HISTORY_DATA, jsonEncode(historyListJson));

  }

  static Future<void> loadFromCache() async {
    final String historyListJson = await CacheManager.getString(StorageKey.HISTORY_DATA);
    if (historyListJson.isNotEmpty) {
      final List<HistoryItem> historyList = (jsonDecode(historyListJson) as List)
          .map((itemJson) => HistoryItem.fromJson(itemJson))
          .toList();
      historyItems.clear();
      historyItems.addAll(historyList);
    }
  }
}