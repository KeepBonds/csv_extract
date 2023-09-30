class AntennaData {
  String antenna = "";
  List<AntennaDataItem>? data;

  AntennaData();

  factory AntennaData.fromJson(Map<String, dynamic> json) {
    return AntennaData()
      ..antenna = json['antenna'] ?? ""
      ..data = (json['data'] as List<dynamic>?)
          ?.map((item) => AntennaDataItem.fromJson(item))
          .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "antenna": this.antenna,
      "data": this.data?.map((item) => item.toJson()).toList(),
    };
  }

  String getAntennaName() {
    switch(antenna) {
      case "0":
        return "MAIN - Ant5";
      case "1":
        return "AUX1 - Ant6";
      case "2":
        return "AUX2 - Ant7";
      case "3":
        return "AUX3 - Ant8";
    }
    return "";
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class AntennaDataItem {
  double? dbm;
  double? frequency;

  AntennaDataItem({this.dbm, this.frequency});

  factory AntennaDataItem.fromJson(Map<String, dynamic> json) {
    return AntennaDataItem(
      dbm: json['dbm']?.toDouble(),
      frequency: json['frequency']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "dbm": this.dbm,
      "frequency": this.frequency,
    };
  }

  @override
  toString() => toJson().toString();
}