import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:csv_extract/object/DirectoryData.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../widgets/dialog/FreeAccessDialog.dart';
import '../manager.dart';

class ScreenshotManager {
  static Future<void> saveScreenshot(GlobalKey globalKey, String parentFolder, DirectoryData? directoryData) async {
    if(PlanManager.isFree) {
      await showFreeAccessDialog(globalKey.currentContext!);
      return;
    }

    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    if(directoryData != null && !kIsWeb) {
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Directory applicationFolder = await getApplicationDocumentsDirectory();
        String titleName = DateFormat("yyyyMMdd_HH_mm_ss").format(DateTime.now());
        String path = '${applicationFolder.path}/$titleName.png';

        await writeFile(byteData, path);

        HistoryManager.saveItem(directoryData, path);
      }
    }

    ui.Image image = await boundary.toImage(pixelRatio: 10.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      String titleName = parentFolder.replaceAll(" ", "_").replaceAll(",", "");
      if(SettingsManager.getState().isShowData) {
        titleName = "${titleName}_showData";
      }
      await writeFile(byteData, '${DirectoryExtractManager.directoryPath}$titleName.png');

      print("SAVE: " + '${DirectoryExtractManager.directoryPath}$titleName.png');
      Fluttertoast.showToast(
          msg: "$titleName SAVED !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  static Future<void> writeFile(ByteData byteData, String path) async {
    if(kIsWeb) {
      await writeFileWeb(byteData, path);
      return;
    }
    await writeFileAndroid(byteData, path);
  }

  static Future<void> writeFileAndroid(ByteData byteData, String path) async {
    Uint8List pngBytes = byteData.buffer.asUint8List();

    File newFile = await File(path).create();
    newFile.writeAsBytesSync(pngBytes);
  }

  static Future<void> writeFileWeb(ByteData byteData, String path) async {
    Uint8List pngBytes = byteData.buffer.asUint8List();
    try {
      AnchorElement()
        ..href = Uri.dataFromBytes(pngBytes, mimeType: 'image/png').toString()
        ..download = path
        ..style.display = 'none'
        ..click();
    } catch (e) {
      print('error while Downloading: $e');
    }
  }
}