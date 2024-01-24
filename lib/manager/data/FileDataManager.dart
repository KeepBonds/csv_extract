import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import '../manager.dart';
import 'package:file_picker/file_picker.dart';
import '../../helper/FileHelper.dart';
import '../../object/object.dart';

class FileDataManager {
  // First extract csv data, then process it
  static Future<FileData?> getFileData(FileSystemEntity file) async {
    List<List<dynamic>> data = await extractDataFromCsv(file);
    String fileName = FileHelper.getFileName(file.path);
    return processFileData(fileName, file.parent.path, data);
  }

  static Future<List<List<dynamic>>> extractDataFromCsv(FileSystemEntity file) async {
    final csvFile = File(file.path).openRead();
    List<List<dynamic>> data = await csvFile
        .transform(utf8.decoder)
        .transform(const CsvToListConverter(),).toList();
    return data;
  }

  // First extract csv data, then process it
  static FileData? processFileData(String fileName, String directoryPath, List<List<dynamic>> data) {
    print("PROCESS FILE: $fileName");

    String band = "";
    String gridSize = "";

    //GET NTP FILES
    final RegExp regex = RegExp(r'NPT_(B\d+|n\d+)_(\d+x\d+)');
    final RegExpMatch? match = regex.firstMatch(fileName);
    if(match != null) {
      print("NTP: $fileName");
      band = match.group(1)!;
      gridSize = match.group(2)!;
    }

    //GET IMEI FILES
    final RegExp regex2 = RegExp(r'IMEI.*_(B\d+|n\d+)');
    final RegExpMatch? match2 = regex2.firstMatch(fileName);
    if(match2 != null) {
      print("IMEI: $fileName");
      band = match2.group(1)!;
    }

    // NO FILES FOUND, RETURN NULL
    if(band.isEmpty) {
      return null;
    }

    String? nameFrequency = findFrequency(fileName);
    print("nameFrequency: $nameFrequency");
    List<List<String>> rows = [];
    if(data.length == 1) { // case where all data is inside a [[]] list and rows are separated by \n
      rows = processOneRow(data);
    } else {
      rows = processMultiRow(data);
    }
    int firstRow = findFirstRow(rows);
    int meanColumn = findColumn(rows, firstRow, "RxAGC_Mean");
    int frequencyColumn = findColumn(rows, firstRow, "Frequency");
    if(frequencyColumn == -1) {
      frequencyColumn = findColumn(rows, firstRow, "Freq");
    }
    int antennaColumn = findColumn(rows, firstRow, "RxId");

    FileData fileData = FileData(
        fileName: fileName,
        parentDirectory: directoryPath,
        band: band,
        nameFrequency: nameFrequency,
        firstRow: firstRow,
        rows: rows,
        meanColumn: meanColumn,
        frequencyColumn: frequencyColumn,
        antennaColumn: antennaColumn,
        antennaNumber: gridSize.isEmpty ? -1 : (int.tryParse(gridSize[0]) ?? -1)
    );
    return fileData;
  }

  static String? findFrequency(String fileName) {
    final RegExp regex2 = RegExp(r'(\d+MHz)');
    final RegExpMatch? match2 = regex2.firstMatch(fileName);
    if(match2?.group(0) != null) {
      return match2!.group(0)!;
    }
    return null;
  }

  static int findFirstRow(List<List<String>> rows) {
    return rows.indexWhere((element) => element.contains("RxAGC_Mean"));
  }

  static int findColumn(List<List<String>> rows, int firstRow, String columnName) {
    return rows[firstRow].indexOf(columnName);
  }

  static List<List<String>> processOneRow(List<List<dynamic>> data) {
    List<List<String>> rows = [];
    for (var element in data) {
      List<String> row = [];
      element.forEach((element2) {
        if(element2.contains("\n")) {
          List<String> split = element2.split("\n");
          row.add(split[0]);
          rows.add(List.from(row));
          row.clear();
          row.add(split[1]);
        } else {
          row.add(element2);
        }
      });
    }
    print(rows.toString());
    return rows;
  }

  static List<List<String>> processMultiRow(List<List<dynamic>> data) {
    List<List<String>> rows = [];
    for (var element in data) {
      List<String> row = [];
      for (var element2 in element) {
        row.add(element2.toString());
      }
      rows.add(row);
    }
    return rows;
  }

  static List<AntennaAverage> getMeanPerAntenna(FileData data) {
    List<AntennaAverage> antennas = [];
    for(int i = 0 ; i < 4 ; i++) {
      AntennaAverage antennaMean = AntennaAverage();
      String antenna = i.toString();
      double? average = getAverage(data, i);

      print("AV $antenna = ${data.band} - $average");
      antennaMean.antenna = antenna;
      antennaMean.average = average;

      antennas.add(antennaMean);
    }
    return antennas;
  }

  static double? getAverage(FileData data, int antennaNb) {
    if(data.antennaNumber != -1 && antennaNb >= data.antennaNumber) return null;

    List<double> testData = [];

    String antenna = antennaNb.toString();
    double totalMean = 0;
    int rowCount = 0;
    for(int i = data.firstRow+1 ; i<data.rows.length ; i++) {
      if(data.rows[i][data.antennaColumn] == antenna) {
        String rowsMean = data.rows[i][data.meanColumn];
        double? meanValue = double.tryParse(rowsMean);
        if (meanValue != null) {
          testData.add(meanValue);
          totalMean += meanValue;
          rowCount++;
        }
      }
    }
    IdentifyPeaksManager.identify(testData);
    print("PROCESSED MEAN: ${data.band} ${totalMean / rowCount}");

    return rowCount > 0 ? totalMean / rowCount : null;
  }

  static List<AntennaData> getAntennaDatas(FileData data) {
    List<AntennaData> antennas = [];
    for(int i = 0 ; i < 4 ; i++) {
      String antenna = i.toString();
      List<AntennaDataItem>? datas = getAntennaData(data, i);

      AntennaData antennaData = AntennaData();
      antennaData.antenna = antenna;
      antennaData.data = datas;

      antennas.add(antennaData);
    }
    return antennas;
  }

  static List<AntennaDataItem>? getAntennaData(FileData data, int antennaNb) {
    if(data.antennaNumber != -1 && antennaNb >= data.antennaNumber) return null;
    List<AntennaDataItem> testData = [];
    String antenna = antennaNb.toString();
    for(int i = data.firstRow+1 ; i<data.rows.length ; i++) {
      if(data.rows[i][data.antennaColumn] == antenna) {
        String rowsMean = data.rows[i][data.meanColumn];
        double? meanValue = double.tryParse(rowsMean);

        String rowsFrequency = data.rows[i][data.frequencyColumn];
        double? frequencyValue = double.tryParse(rowsFrequency);

        if (meanValue != null && frequencyValue != null) {
          AntennaDataItem item = AntennaDataItem(
            dbm: meanValue,
            frequency: frequencyValue
          );
          testData.add(item);
        }
      }
    }
    return testData;
  }

  /// WEB
  static Future<FileData?> getFileDataWeb(PlatformFile file, String directory) async {
    List<List<dynamic>> data = await extractDataFromCsvWeb(file);
    return processFileData(file.name, directory, data);
  }

  static Future<List<List<dynamic>>> extractDataFromCsvWeb(PlatformFile file) async {
    return const CsvToListConverter().convert(utf8.decode(file.bytes!));
  }
}