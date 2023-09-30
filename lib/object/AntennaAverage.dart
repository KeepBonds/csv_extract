class AntennaAverage {
  String antenna = "";
  double? average;

  AntennaAverage();

  factory AntennaAverage.fromJson(Map<String, dynamic> json) {
    return AntennaAverage()
      ..antenna = json['antenna'] ?? ""
      ..average = json['average']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      "antenna": this.antenna,
      "average": this.average,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}