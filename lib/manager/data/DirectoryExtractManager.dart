import 'dart:io';
import 'package:file_picker/file_picker.dart';

import '../manager.dart';
import '../../helper/FileHelper.dart';
import '../../object/object.dart';

class DirectoryExtractManager {
  static clear() {
    directoryPath = "";
    directoryData.clear();
    dirBands = {};
  }

  static String directoryPath = "";
  static List<DirectoryData> directoryData = [];
  static Map<String, List<BandsAverage>> dirBands = {};

  static Future<void> getDirectoryData(Directory directory) async {
    directoryPath = directory.path;

    List<FileSystemEntity> csvFiles = extractCsvFiles(directory);

    // Sort list per Directory they belond to
    Map<String, List<FileSystemEntity>> sortedList = sortAndGroupFilesByDirectory(csvFiles);

    // Process data in DirectoryData which hold the file main data for each directory
    // FileData contains the important value for each file
    directoryData = await processToDirectoryData(sortedList);
    dirBands = await processDirBands();
  }

  // Get every NPT csv files in the Directory
  static List<FileSystemEntity> extractCsvFiles(Directory directory) {
    print("[extractCsvFiles]: " + directory.path);
    print("[extractCsvFiles]: " + directory.listSync().toString());
    List<FileSystemEntity> csvFiles = [];
    csvFiles = directory.listSync(recursive: true, followLinks: false);
    csvFiles.removeWhere((element) => !FileHelper.isCsvFile(FileHelper.getFileExtension(element.path)));
    csvFiles.removeWhere((element) => !FileHelper.getFileName(element.path).contains("NPT") && !FileHelper.getFileName(element.path).contains(RegExp("IMEI.*_raw")));
    return csvFiles;
  }

  // Sort files per directory, if the directory isn't in the list, add a new entry
  static Map<String, List<FileSystemEntity>> sortAndGroupFilesByDirectory(List<FileSystemEntity> filePaths) {
    Map<String, List<FileSystemEntity>> fileListsByDirectory = {};
    for (FileSystemEntity file in filePaths) {
      final Directory parentDirectory = file.parent;
      if (!fileListsByDirectory.containsKey(parentDirectory.path)) {
        fileListsByDirectory[parentDirectory.path] = [];
      }
      fileListsByDirectory[parentDirectory.path]!.add(file);
    }
    // Sort files within each directory
    fileListsByDirectory.forEach((directory, files) {
      files.sort((a, b) => a.path.compareTo(b.path));
    });
    return fileListsByDirectory;
  }

  // Process each file to its assign DirectoryData
  static Future<List<DirectoryData>> processToDirectoryData(Map<String, List<FileSystemEntity>> sortedList) async {
    List<DirectoryData> directoryData = [];
    for (MapEntry<String, List<FileSystemEntity>> entry in sortedList.entries) {
      String directory = entry.key;
      List<FileSystemEntity> files = entry.value;

      List<FileData> datas = [];
      for (FileSystemEntity file in files) {
        FileData? data = await FileDataManager.getFileData(file);
        if (data != null) datas.add(data);
      }
      DirectoryData dirData = DirectoryData(directory: directory, files: datas);
      directoryData.add(dirData);
    }
    return directoryData;
  }

  static Map<String, List<BandsAverage>> processDirBands() {
    Map<String, List<BandsAverage>> dirBands = {};
    for(int i = 0 ; i < directoryData.length ; i++) {
      dirBands[directoryData[i].directory] = sortTable(directoryData[i].files);
    }
    return dirBands;
  }

  static List<BandsAverage> sortTable(List<FileData> files) {
    List<BandsAverage> bandsValues = [];
    for(FileData file in files) {
      BandsAverage? bandsAverage = BandsManager.processBand(file);
      if(bandsAverage != null) {
        bandsValues.add(bandsAverage);
      }
    }

    List<BandsAverage> missingBands = addMissingBands(bandsValues);
    bandsValues.addAll(missingBands);

    bandsValues.sort((e1, e2) {
      String alphaPart1 = e1.bands.band.substring(0,1);
      String numPart1 = e1.bands.band.substring(1,e1.bands.band.length);

      String alphaPart2 = e2.bands.band.substring(0,1);
      String numPart2 = e2.bands.band.substring(1,e2.bands.band.length);

      if (alphaPart1 != alphaPart2) {
        return alphaPart1.compareTo(alphaPart2);
      }

      return int.parse(numPart1).compareTo(int.parse(numPart2));
    });

    return bandsValues;
  }

  static List<BandsAverage> addMissingBands(List<BandsAverage> foundBands) {
    List<BandsAverage> missingBands = [];
    for(Bands bands in BandsManager.bands) {
      int index = foundBands.indexWhere((element) => element.bands.band == bands.band);
      if(index == -1) {
        missingBands.add(
            BandsAverage(bands: bands, antennaAverage: [], antennaDatas: [])
        );
      }
    }
    return missingBands;
  }



  /// WEB
  static Future<Map<String, List<PlatformFile>>?> getDirectoryWeb() async {
    FilePickerResult? pickerResult = await FilePicker.platform.pickFiles(allowMultiple: true);  //String? selectedDirectory = await FilePicker.platform.getDirectoryPath(dialogTitle: "Select app directory");

    if(pickerResult != null) {
      List<PlatformFile> files = pickerResult.files;
      files.removeWhere((element) => !FileHelper.isCsvFile(FileHelper.getFileExtension(element.name)));
      files.removeWhere((element) => !element.name.contains("NPT") && !element.name.contains(RegExp("IMEI.*_raw")));
      Map<String, List<PlatformFile>> fileListsByDirectory = {};
      for (PlatformFile file in files) {
        final Directory parentDirectory = Directory((directoryData.length+1).toString());
        if (!fileListsByDirectory.containsKey(parentDirectory.path)) {
          fileListsByDirectory[parentDirectory.path] = [];
        }
        fileListsByDirectory[parentDirectory.path]!.add(file);
      }
      // Sort files within each directory
      fileListsByDirectory.forEach((directory, files) {
        files.sort((a, b) => a.name.compareTo(b.name));
      });
      return fileListsByDirectory;
    }
    return null;
  }

  static Future<void> getDirectoryDataWeb() async {
    Map<String, List<PlatformFile>>? list = await getDirectoryWeb();
    if(list != null) {
      directoryData = await processToDirectoryDataWeb(list);
      dirBands = await processDirBands();
    }
  }

  // Process each file to its assign DirectoryData
  static Future<List<DirectoryData>> processToDirectoryDataWeb(Map<String, List<PlatformFile>> list) async {
    List<DirectoryData> directoryData = [];
    for (MapEntry<String, List<PlatformFile>> entry in list.entries) {
      String directory = entry.key;
      List<PlatformFile> files = entry.value;

      List<FileData> datas = [];
      for (PlatformFile file in files) {
        FileData? data = await FileDataManager.getFileDataWeb(file, (directoryData.length+1).toString());
        if (data != null) datas.add(data);
      }
      DirectoryData dirData = DirectoryData(directory: directory, files: datas);
      directoryData.add(dirData);
    }
    return directoryData;
  }
}