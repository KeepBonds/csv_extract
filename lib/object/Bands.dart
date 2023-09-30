import 'package:csv_extract/manager/manager.dart';

class Bands {
  final String band;
  final String frequency;
  final String otherData;
  final double? specAntenna1;
  final double? specAntenna2;
  final double? specAntenna3;
  final double? specAntenna4;

  Bands({
    required this.band,
    required this.frequency,
    required this.otherData,
    this.specAntenna1,
    this.specAntenna2,
    this.specAntenna3,
    this.specAntenna4,
  });

  double? getSpecFromAntenna(String antenna) {
    double? spec;
    switch(antenna) {
      case "0":
        spec = specAntenna1;
      case "1":
        spec = specAntenna2;
      case "2":
        spec = specAntenna3;
      case "3":
        spec = specAntenna4;
    }
    if(SettingsManager.getState().isShow95 && spec != null) {
      return -95.0;
    }
    return spec;
  }

  factory Bands.fromJson(Map<String, dynamic> json) {
    return Bands(
      band: json['band'],
      frequency: json['frequency'],
      otherData: json['otherData'],
      specAntenna1: json['specAntenna1']?.toDouble(),
      specAntenna2: json['specAntenna2']?.toDouble(),
      specAntenna3: json['specAntenna3']?.toDouble(),
      specAntenna4: json['specAntenna4']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "band": this.band,
      "frequency": this.frequency,
      "otherData": this.otherData,
      "specAntenna1": this.specAntenna1,
      "specAntenna2": this.specAntenna2,
      "specAntenna3": this.specAntenna3,
      "specAntenna4": this.specAntenna4,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
