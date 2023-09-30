class FileData {
  String fileName = "";
  String band = "";
  String? nameFrequency;
  int antennaNumber = 0;
  int firstRow = 0;
  List<List<String>> rows = [];
  int meanColumn = -1; //RxAGC_Mean
  int frequencyColumn = -1; //RxAGC_Mean
  int antennaColumn = -1;
  String parentDirectory = "";

  FileData({
    required this.fileName,
    required this.band,
    required this.nameFrequency,
    required this.antennaNumber,
    required this.firstRow,
    required this.rows,
    required this.meanColumn,
    required this.frequencyColumn,
    required this.antennaColumn,
    required this.parentDirectory,
  });

  Map<String, dynamic> toJson() {
    return {
      "fileName": this.fileName,
      "band": this.band,
      "nameFrequency": this.nameFrequency,
      "antennaNumber": this.antennaNumber,
      "firstRow": this.firstRow,
      "rows": this.rows,
      "meanColumn": this.meanColumn,
      "frequencyColumn": this.frequencyColumn,
      "antennaColumn": this.antennaColumn,
      "parentDirectory": this.parentDirectory,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}