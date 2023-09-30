import 'dart:io';
import 'package:csv_extract/object/object.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../constants/constants.dart';
import '../../widgets/dialog/FreeAccessDialog.dart';
import '../manager.dart';

enum ColorEnum {
  green, lightGreen, yellow, red, grey, none
}

const List<String> abc = [
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
  "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
];

double widthDivider = 5;

class ExcelCreationManager {
  static Future<void> create(BuildContext context, DirectoryData data) async {
    if(PlanManager.isFree) {
      await showFreeAccessDialog(context);
      return;
    }

    List<BandsAverage> avgs = DirectoryExtractManager.dirBands[data.directory] ?? [];

    Excel excel = Excel.createExcel();
    Sheet sheetObject = excel[excel.getDefaultSheet() ?? 'Bands'];

    handleFirstRow(sheetObject);

    int skip = 0;
    for(int i = 0 ; i < avgs.length ; i++) {
      // HANDLE TITLE FIRST COLUMN
      if (!(!SettingsManager.getState().isShowX && avgs[i].antennaAverage.isEmpty)) {
          handleTitleColumn(sheetObject, avgs[i], i-skip);
          for (int j = 0; j < 4; j++) {
            handleDataColumn(sheetObject, avgs[i], j, i-skip, j);
          }
      } else {
        skip += 1;
      }
    }

    /*
    List<String> dataList = ['Google', 'loves', 'Flutter', 'and', 'Flutter', 'loves', 'Excel'];
         sheetObject.insertRowIterables(dataList, 8);
     */

    List<int>? fileBytes = excel.save();
    if(kIsWeb) {
      return;
    }

    String directory = DirectoryExtractManager.directoryPath;


    if(fileBytes != null) {
      int lastIndex = data.directory.lastIndexOf("/");
      String dir = data.directory.substring(0, lastIndex);
      String file = data.directory.substring(lastIndex, data.directory.length).replaceAll(" ", "_").replaceAll(",", "") + ".xlsx";


      File(dir+file)
        ..createSync()
        ..writeAsBytesSync(fileBytes);
      print("SAVED " +dir+file);
      Fluttertoast.showToast(
          msg: dir+file + " SAVED !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0
      );
      return;
    }
    print("OOPS " + "$directory/${data.directory}.xlsx");
  }


  static Future<void> handleFirstRow(Sheet sheetObject) async {
    initFirstColumn(sheetObject, "A1");
    initSecondColumn(sheetObject, abc[1]+"1");
    initThirdColumn(sheetObject, abc[2]+"1");
    initForthColumn(sheetObject, abc[3]+"1");
    initFifthColumn(sheetObject, abc[4]+"1");
  }

  static void initFirstColumn(Sheet sheetObject, String index) async {
    int fontSize = SettingsManager.getState().headerFontSize.toInt();
    double additionalWidth = (fontSize - 14) * 3;
    sheetObject.setColWidth(0, 40 + (additionalWidth));

    Data cell1 = sheetObject.cell(CellIndex.indexByString(index));
    cell1.value = "LTE/NR Bands";
    cell1.cellStyle = cellStyle(null, true);
  }

  static void initSecondColumn(Sheet sheetObject, String index) {
    double colWidth = SettingsManager.getState().rowWidth / widthDivider;
    sheetObject.setColWidth(1, colWidth + (0.1));
    Data cell2 = sheetObject.cell(CellIndex.indexByString(index));
    cell2.value = "MAIN\nAnt5";
    cell2.cellStyle = cellStyle();
  }

  static void initThirdColumn(Sheet sheetObject, String index) {
    double colWidth = SettingsManager.getState().rowWidth / widthDivider;
    Data cell3 = sheetObject.cell(CellIndex.indexByString(index));
    cell3.value = "AUX1\nAnt6";
    cell3.cellStyle = cellStyle();
    sheetObject.setColWidth(2, colWidth + (0.2));
  }

  static void initForthColumn(Sheet sheetObject, String index) {
    double colWidth = SettingsManager.getState().rowWidth / widthDivider;
    Data cell4 = sheetObject.cell(CellIndex.indexByString(index));
    cell4.value = "AUX2\nAnt7";
    cell4.cellStyle = cellStyle();
    sheetObject.setColWidth(3, colWidth + (0.3));
  }

  static void initFifthColumn(Sheet sheetObject, String index) {
    double colWidth = SettingsManager.getState().rowWidth / widthDivider;
    Data cell5 = sheetObject.cell(CellIndex.indexByString(index));
    cell5.value = "AUX3\nAnt8";
    cell5.cellStyle = cellStyle();
    sheetObject.setColWidth(4, colWidth + (0.4));
  }

  static void handleTitleColumn(Sheet sheetObject, BandsAverage bandsAverage, int rowIndex) {
    Data cell = sheetObject.cell(CellIndex.indexByString('A${rowIndex+2}'));
    cell.value = "${bandsAverage.bands.band} - ${bandsAverage.fileFrequency ?? "??MHz"}, ${bandsAverage.bands.otherData}";
    cell.cellStyle = cellStyle(null, true);
  }

  static void handleDataColumn(Sheet sheetObject, BandsAverage bandsAverage, int antennaIndex, int rowIndex, int columnIndex) {
    Data cell = sheetObject.cell(CellIndex.indexByString('${abc[columnIndex+1]}${rowIndex+2}'));

    double? spec = bandsAverage.bands.getSpecFromAntenna(antennaIndex.toString());
    if(spec == null) {
      cell.value = "/";
      cell.cellStyle = cellStyle(getHexaColor(ColorEnum.none));
      return;
    }

    AntennaAverage? antenna = findAntenna(bandsAverage, antennaIndex.toString());
    if(bandsAverage.antennaAverage.isEmpty || antenna?.average == null) {
      cell.value = "X";
      cell.cellStyle = cellStyle(getHexaColor(ColorEnum.grey));
      return;
    }

    double difference = spec - antenna!.average!;
    String value = difference > 1 ? "PASS" : difference.toStringAsFixed(1);

    cell.value = value;
    if(difference > 1) { // x < spec-1 | ie below -96
      cell.cellStyle = cellStyle(getHexaColor(ColorEnum.green));
    } else if(difference > 0) { // spec-1 < x < spec | ie between -96 & -95
      print(difference.toString() + " - " + " light green");
      cell.cellStyle = cellStyle(getHexaColor(ColorEnum.lightGreen));;
    } else if(difference > -1) { // spec < x < spec+1 | ie between -95 & -94
      print(difference.toString() + " - " + " yellow");
      cell.cellStyle = cellStyle(getHexaColor(ColorEnum.yellow));
    } else {    // above x > spec+1 | ie -94
      print(difference.toString() + " - " + " red");
      cell.cellStyle = cellStyle(getHexaColor(ColorEnum.red));
    }
  }

  static AntennaAverage? findAntenna(BandsAverage band, String antenna) {
    for(AntennaAverage antennaAverage in band.antennaAverage) {
      if(antennaAverage.antenna == antenna) {
        return antennaAverage;
      }
    }
    return null;
  }

  static String getHexaColor(ColorEnum colorEnum) {
    ColorTemplate colorTemplate =  (SettingsManager.getState().template?? defaultTemplate);

    Color myColor = Colors.white;
    switch(colorEnum){
      case ColorEnum.green:
        myColor = colorTemplate.pass;
      case ColorEnum.lightGreen:
        myColor = colorTemplate.marginPass;
      case ColorEnum.yellow:
        myColor = colorTemplate.marginFail;
      case ColorEnum.red:
        myColor = colorTemplate.fail;
      case ColorEnum.grey:
        myColor = colorTemplate.noData;
      case ColorEnum.none:
        myColor = colorTemplate.noSpec;
    }
    return '#${myColor.value.toRadixString(16)}';
  }

  static CellStyle cellStyle([String? color, bool? alignStart]) {
    SettingsManager manager = SettingsManager.getState();
    if(color == null) { // header style
      return CellStyle(fontFamily : getFontFamily(FontFamily.Calibri), verticalAlign: VerticalAlign.Center, horizontalAlign: (alignStart ?? false) ? HorizontalAlign.Left: HorizontalAlign.Center, bold: manager.isHeaderBold, italic: manager.isHeaderItalic, fontSize: manager.headerFontSize.toInt());
    }
    return CellStyle(backgroundColorHex: color, fontFamily : getFontFamily(FontFamily.Calibri), verticalAlign: VerticalAlign.Center, horizontalAlign: HorizontalAlign.Center, bold: manager.isValueBold, italic: manager.isValueItalic, fontSize: manager.valueFontSize.toInt());
  }


  static List<BandsAverage> getSelectionAverage(String dir) {
    return DirectoryExtractManager.dirBands.containsKey(dir) ? (DirectoryExtractManager.dirBands[dir] ?? []) : (HistoryManager.loadedItems.firstWhere((element) => element.date == dir).getBandsAverage());
  }

  static Future<void> createCompare(BuildContext context, DirectoryData data, List<String> hideBands, List<String> selectedDirectories) async {
    if(PlanManager.isFree) {
      await showFreeAccessDialog(context);
      return;
    }

    bool hideNoSpec() {
      for(int i = 0 ; i < selectedDirectories.length ; i++) {
        List<BandsAverage> bandsValues = getSelectionAverage(selectedDirectories[i]);
        for(int i = 0 ; i < bandsValues.length ; i++) {
          BandsAverage band = bandsValues[i];
          bool hideIndex = (hideBands.contains(bandsValues[i].bands.band));
          bool hideX = (!SettingsManager.getState().isShowX && band.antennaAverage.isEmpty);

          if(!hideIndex && !hideX) {
            double? specAntenna2 = band.bands.getSpecFromAntenna("2");
            double? specAntenna3 = band.bands.getSpecFromAntenna("3");
            if(specAntenna2 != null || specAntenna3 != null) return false;
          }
        }
      }
      return true;
    }

    List<BandsAverage> avgs = getSelectionAverage(selectedDirectories.first);

    Excel excel = Excel.createExcel();
    Sheet sheetObject = excel[excel.getDefaultSheet() ?? 'Bands'];

    initFirstColumn(sheetObject, "A2");

    bool isHideNoSpec = hideNoSpec();
    int skip = 0;
    for(int i = 0 ; i < avgs.length ; i++) { // ROW
      bool hideIndex = (hideBands.contains(avgs[i].bands.band));
      bool hideX = (!SettingsManager.getState().isShowX && avgs[i].antennaAverage.isEmpty);

      if(!hideIndex && !hideX) {
        handleTitleColumn(sheetObject, avgs[i], (i+1)-skip);

        for(int j = 0 ; j < selectedDirectories.length ; j++) { // TABLE
          List<BandsAverage> tableAverage = getSelectionAverage(selectedDirectories[j]);
          int column = (j*(isHideNoSpec ? 2 : 4));

          Data titleDir = sheetObject.cell(CellIndex.indexByString(abc[column+1]+"1"));
          titleDir.value = selectedDirectories[j].split("/").last.trim();
          CellIndex startIndex = CellIndex.indexByString(abc[column+1]+"1");
          CellIndex endIndex = CellIndex.indexByString(abc[column+ (isHideNoSpec ? 2 : 4)]+"1");
          sheetObject.merge(startIndex, endIndex);

          initSecondColumn(sheetObject, abc[column+1] + "2");
          initThirdColumn(sheetObject,  abc[column+2] + "2");
          if(!isHideNoSpec) {
            initForthColumn(sheetObject, abc[column+3] + "2");
            initFifthColumn(sheetObject, abc[column+4] + "2");
          }

          for (int x = 0; x < (isHideNoSpec ? 2 : 4); x++) {
            handleDataColumn(sheetObject, tableAverage[i], x, (i+1)-skip, x + (j*(isHideNoSpec ? 2 : 4)));
          }
        }
      } else {
        skip += 1;
      }
    }

    List<int>? fileBytes = excel.save();

    if(fileBytes != null) {
      String directory = DirectoryExtractManager.directoryPath;
      String time = DateFormat("yyyyMMdd_HH_mm_ss").format(DateTime.now());
      String file = "compare_$time.xlsx";

      File(directory + file)
        ..createSync()
        ..writeAsBytesSync(fileBytes);
      print("SAVED $directory$file");
      Fluttertoast.showToast(
          msg: "$directory$file SAVED !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0
      );
      return;
    }
  }
}