import 'dart:io';
import 'package:directory_path/directory_path.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../manager.dart';

class DirectoryPickerManager {
  static List<String> androidPaths = [
    "/mnt/media_rw/",
    "/sys/bus/usb/devices/",
    "/mnt/sdcard_rw/",
    "/storage/usb0/",
    "/storage/usbdisk0/",
    "/storage/sdcard0/",
  ];

  static Future<Directory?> getDirectory(context) async {
    DirectoryExtractManager.clear();

    Directory? directory;
    try {
      directory = await getAndroidDirectory();
      print("DIR: ${directory.toString()}");
    } catch (e) {
      print("ERROR WHILE PROCESSING DIRECTORY: " + e.toString());
      showDialog(context: context, builder: (context) {
        return const Dialog(
          child: Text("Error while processing directory"),
        );
      });
    }
    return directory;
  }

  static Future<Directory?> getAndroidDirectory() async {
    await [
      Permission.storage,
      Permission.mediaLibrary,
      Permission.manageExternalStorage,
      Permission.accessMediaLocation,
      Permission.photos
    ].request();

    String? selectedDirectory = await DirectoryPath().getDirectoryPath();  //String? selectedDirectory = await FilePicker.platform.getDirectoryPath(dialogTitle: "Select app directory");

    if(selectedDirectory != null) {
      Directory? directory = await getAvailableDirectory(selectedDirectory);
      return directory;
    }
    return null;
  }

  static Future<Directory?> getAvailableDirectory(String uri) async {
    Directory internalDir = Directory("$uri/");
    if(internalDir.existsSync()) {
      return internalDir;
    }

    for(String path in androidPaths) {
      String processedPath = path;

      if(uri.contains("content://")) {
        processedPath = path + uri.split("/").last;
      }
      processedPath = processedPath.replaceAll("%3A", "/");
      processedPath = Uri.decodeQueryComponent(processedPath);
      if(!processedPath.endsWith("/")) {
        processedPath += "/";
      }

      print("TEST PATH: " + processedPath);
      Directory externalDir = Directory(processedPath);
      print("externalDir: " + externalDir.existsSync().toString());
      if(externalDir.existsSync()) {
        return externalDir;
      }
    }

    return null;
  }
}