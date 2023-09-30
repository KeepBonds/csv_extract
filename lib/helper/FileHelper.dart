import 'dart:io';
import 'package:path/path.dart';

class FileHelper {
  static bool endsWithFileExtension(String element){
    List<String> extensionFileList = [];

    extensionFileList.addAll(wordExtensionList);
    extensionFileList.addAll(excelExtensionList);
    extensionFileList.addAll(powerPointExtensionList);
    extensionFileList.addAll(otherOfficeExtensionList);
    extensionFileList.addAll(musicExtensionList);
    extensionFileList.addAll(videoExtensionList);
    extensionFileList.addAll(pictureExtensionList);
    extensionFileList.addAll(archiveExtensionList);
    extensionFileList.addAll(othersFileList);

    for(String extension in extensionFileList){
      if(element.endsWith(extension)) return true;
    }
    return false;
  }

  static const List<String> wordExtensionList = [
    ".doc",
    ".dot",
    ".wbk",
    ".docx",
    ".docm",
    ".dotx",
    ".dotm",
    ".docb"
  ];

  static const List<String> excelExtensionList = [
    ".xls",
    ".xlt",
    ".xlm",
    ".xlsx",
    ".xlsm",
    ".xltx",
    ".xltm",
    ".xlsb",
    ".xla",
    ".xlam",
    ".xll",
    ".xlw"
  ];

  static const List<String> powerPointExtensionList = [
    ".ppt",
    ".pot",
    ".pps",
    ".pptx",
    ".pptm",
    ".potx",
    ".potm",
    ".ppam",
    ".ppsx",
    ".ppsm",
    ".sldx",
    ".sldm"
  ];

  static const List<String> otherOfficeExtensionList = [
    ".one",
    ".pub",
    ".xps"
  ];

  static const List<String> musicExtensionList = [
    '.mp3',
    '.wma',
    '.wav',
    '.aif',
    '.cda',
    '.ogg'
  ];

  static const List<String> videoExtensionList = [
    '.avi',
    '.amv',
    '.flv',
    '.m4v',
    '.mp4',
    '.mpg',
    '.mpeg',
    '.mkv',
    '.mov',
    '.qt',
    '.webm',
    '.wmv',
  ];

  static const List<String> pictureExtensionList = [
    '.jpg',
    '.jpeg',
    '.png',
    '.bmp',
    '.ico',
    '.gif',
    '.tif',
    '.tiff'
  ];

  static const List<String> archiveExtensionList = [
    '.7z',
    '.zip',
    '.tar.gz',
    '.rar',
    '.pkg'
  ];

  static const List<String> othersFileList = [
    '.pdf',
    '.txt',
    '.html',
  ];

  static const List<String> csvFileList = [
    '.csv',
  ];

  static bool isOfficeFile(extension) {
    if(wordExtensionList.contains(extension) ||
        excelExtensionList.contains(extension) ||
        powerPointExtensionList.contains(extension) ||
        otherOfficeExtensionList.contains(extension)) {
      return true;
    }
    return false;
  }

  static bool isCsvFile(String extension) {
    return csvFileList.contains(extension.toLowerCase());
  }

  static bool isWordFile(String extension) {
    return wordExtensionList.contains(extension.toLowerCase());
  }

  static bool isExcelFile(String extension) {
    return excelExtensionList.contains(extension.toLowerCase());
  }

  static bool isPowerPointFile(String extension) {
    return powerPointExtensionList.contains(extension.toLowerCase());
  }

  static bool isMusicFile(String extension) {
    return musicExtensionList.contains(extension.toLowerCase());
  }

  static bool isVideoFile(String extension) {
    return videoExtensionList.contains(extension.toLowerCase());
  }

  static bool isPictureFile(String extension) {
    return pictureExtensionList.contains(extension.toLowerCase());
  }

  static bool isArchiveFile(String extension) {
    return archiveExtensionList.contains(extension.toLowerCase());
  }

  static String getFileExtension(file) {
    if(file is File) {
      return extension(file.path);
    }
    return extension(file);
  }

  static String getDirectoryName(file) {
    if(file is File) {
      return dirname(file.path);
    }
    return dirname(file);
  }

  static String getFileName(file) {
    if(file is File) {
      return basename(file.path);
    }
    return basename(file);
  }

  static String getFileNameWithoutExtension(file) {
    if(file is File) {
      return withoutExtension(basename(file.path));
    }
    return withoutExtension(basename(file));
  }

  static String getFileNameWithoutRagicPrefix(String fileName) {
    var fileNameArray = fileName.split('@');
    if (fileNameArray.length == 2) {
      fileName = fileNameArray[1];
    }
    return fileName;
  }

  static String getFileSizeFromBytes(int size){
    double bytes = size.toDouble();
    if((bytes / 1024)<0.1){
      return bytes.toStringAsFixed(1) + " B";
    }
    double kilobytes = (bytes / 1024);
    if((kilobytes / 1024)<0.1){
      return kilobytes.toStringAsFixed(1) + " KB";
    }
    double megabytes = (kilobytes / 1024);
    if((megabytes / 1024)<0.1){
      return megabytes.toStringAsFixed(1) + " MB";
    }
    double gigabytes = (megabytes / 1024);
    return gigabytes.toStringAsFixed(1) + " GB";
  }
}