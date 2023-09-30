import 'package:intl/intl.dart';

import 'object.dart';

class HistoryItem {
  String originFolder;
  String date;
  String img;
  dynamic data;

  HistoryItem({
    required this.originFolder,
    required this.img,
    required this.data,
  }) : date = DateFormat("yyyyMMdd_HH_mm_ss").format(DateTime.now());

  DateTime getDay() {
    int year = int.tryParse(date.substring(0, 4)) ?? -1;
    int month = int.tryParse(date.substring(4, 6)) ?? -1;
    int day = int.tryParse(date.substring(6, 8)) ?? -1;

    return DateTime(year, month, day);
  }

  DateTime parseDate() {
    int year = int.tryParse(date.substring(0, 4)) ?? -1;
    int month = int.tryParse(date.substring(4, 6)) ?? -1;
    int day = int.tryParse(date.substring(6, 8)) ?? -1;
    int hour = int.tryParse(date.substring(9, 11)) ?? -1;
    int minute = int.tryParse(date.substring(12, 14)) ?? -1;
    int second = int.tryParse(date.substring(15, 17)) ?? -1;

    return DateTime(year, month, day, hour, minute, second);
  }

  String getTimeString() {
    return DateFormat("yyyy/MM/dd HH:mm:ss").format(parseDate());
  }

  List<BandsAverage> getBandsAverage() {
    List<BandsAverage> bandsValues = [];
    if(data is List) {
      data.forEach((element) {
        if(element is BandsAverage) {
          bandsValues.add(element);
        } else {
          BandsAverage average = BandsAverage.fromJson(element);
          bandsValues.add(average);
        }
      });
    }
    return bandsValues;
  }

  HistoryItem.fromJson(Map<String, dynamic> json)
      : originFolder = json['originFolder'] ?? "",
        date = json['date'],
        img = json['img'],
        data = List<dynamic>.from(json['data']);

  Map<String, dynamic> toJson() => {
    'originFolder': originFolder,
    'date': date,
    'img': img,
    'data': data,
  };
}