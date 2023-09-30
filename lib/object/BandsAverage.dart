import 'object.dart';

class BandsAverage {
  Bands bands;
  List<AntennaAverage> antennaAverage;
  List<AntennaData> antennaDatas; // Add this parameter
  String? fileFrequency;
  String? directoryName;

  BandsAverage({
    required this.bands,
    required this.antennaAverage,
    required this.antennaDatas, // Update the constructor
    this.fileFrequency,
    this.directoryName
  });

  String getRowHeaderValue() {
    return "${bands.band} - ${fileFrequency ?? bands.frequency}, ${bands.otherData}";
  }

  factory BandsAverage.fromJson(Map<String, dynamic> json) {
    return BandsAverage(
      bands: Bands.fromJson(json['bands']),
      antennaAverage: (json['antennaAverage'] as List<dynamic>)
          .map((item) => AntennaAverage.fromJson(item))
          .toList(),
      antennaDatas: (json['antennaDatas'] as List<dynamic>)
          .map((item) => AntennaData.fromJson(item))
          .toList(),
      fileFrequency: json['fileFrequency'],
      directoryName: json['directoryName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bands": this.bands,
      "antennaAverage": this.antennaAverage.map((data) => data.toJson()).toList(),
      "antennaDatas": this.antennaDatas.map((data) => data.toJson()).toList(),
      "fileFrequency": this.fileFrequency,
      "directoryName": this.directoryName
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}