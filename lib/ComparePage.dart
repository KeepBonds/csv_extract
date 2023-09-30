import 'dart:async';
import 'package:csv_extract/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'object/object.dart';
import 'widgets/dialog/DirectorySelectorDialog.dart';
import 'widgets/widgets.dart';
import 'manager/manager.dart';

const double kFileNameHeight = 24.0;

class ComparePage extends StatefulWidget {
  const ComparePage({Key? key}) : super(key: key);

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  GlobalKey globalKey =  GlobalKey();

  List<String> selectedDirectories = [];
  List<String> hideBands = [];

  bool isDownloadingFile = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => showSelectDialog());
  }

  showSelectDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return const DirectorySelectorDialog();
        }
    ).then((value) {
      if(value != null) {
        selectedDirectories = value;
        process();
        setState(() {});
      } else {
        Navigator.pop(context);
      }
    });
  }


  List<List<BandsAverage>> get getAllBandsAverage {
    List<List<BandsAverage>> allBandsAverage = [];
    for(String dir in selectedDirectories) {
      List<BandsAverage> getSelectAverage = getSelectionAverage(dir);
      allBandsAverage.add(getSelectAverage);
    }
    return allBandsAverage;
  }

  List<BandsAverage> getSelectionAverage(String dir) {
    return DirectoryExtractManager.dirBands.containsKey(dir) ? (DirectoryExtractManager.dirBands[dir] ?? []) : (HistoryManager.loadedItems.firstWhere((element) => element.date == dir).getBandsAverage());
  }

  process() {
    for(String dir in selectedDirectories) {
      List<BandsAverage> bandsAverage = getSelectionAverage(dir);
      for(int i = 0 ; i < bandsAverage.length ; i++) {
        if(bandsAverage[i].antennaAverage.isEmpty && !hideBands.contains(bandsAverage[i].bands.band)) {
          hideBands.add(bandsAverage[i].bands.band);
        }
      }
    }
  }

  bool hideBand(String band) => (hideBands.contains(band));
  bool hideX(BandsAverage band) => (!SettingsManager.getState().isShowX && band.antennaAverage.isEmpty);

  bool hideNoSpec() {
    for(int i = 0 ; i < selectedDirectories.length ; i++) {
      List<BandsAverage> bandsValues = getSelectionAverage(selectedDirectories[i]);
      for(int i = 0 ; i < bandsValues.length ; i++) {
        BandsAverage bandsAverage = bandsValues[i];
        if(!hideBand(bandsAverage.bands.band) && !hideX(bandsAverage)) {
          double? specAntenna2 = bandsAverage.bands.getSpecFromAntenna("2");
          double? specAntenna3 = bandsAverage.bands.getSpecFromAntenna("3");
          if(specAntenna2 != null || specAntenna3 != null) return false;
        }
      }
    }
    return true;
  }

  Future<void> downloadFile() async {
    setState(() {
      isDownloadingFile = true;
    });
    String time = DateFormat("yyyyMMdd_HH_mm_ss").format(DateTime.now());
    String file = "compare_$time.xlsx";

    await ScreenshotManager.saveScreenshot(globalKey, file, null);
    setState(() {
      isDownloadingFile = false;
    });
  }

  Future<void> downloadExcel() async {
    await ExcelCreationManager.createCompare(context, DirectoryExtractManager.directoryData.first, hideBands, selectedDirectories);
  }

  @override
  Widget build(BuildContext context) {
    bool isHideNoSpec = hideNoSpec();
    BoxConstraints constraints = BoxConstraints(
      minHeight: kFileNameHeight * (isHideNoSpec ? 2 : 1),
      maxHeight: kFileNameHeight * (isHideNoSpec ? 2 : 1),
      maxWidth: (SettingsManager.getState().rowWidth - 4) * (isHideNoSpec ? 2 : 4),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if(selectedDirectories.isNotEmpty)
            IconButton(
                onPressed: downloadExcel,
                icon: excelPngIcon(size: 20)
            ),
          if(selectedDirectories.isNotEmpty)
            isDownloadingFile ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 14.0),
              height: 20,
              width: 20,
              child: const CircularProgressIndicator(strokeWidth: 1.5, color: Colors.blueGrey,),
            ) : IconButton(
                onPressed: downloadFile,
                icon: downloadPngIcon(size: 20)
            )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: RepaintBoundary(
            key: globalKey,
            child: Container(
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(selectedDirectories.isNotEmpty)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            minHeight: constraints.minHeight,
                            maxHeight: constraints.maxHeight,
                          ),
                        ),
                        BandsTableHeader(
                            bandsValues: getSelectionAverage(selectedDirectories.first),
                            hideBands: hideBands,
                            allBands: getAllBandsAverage
                        )
                      ],
                    ),
                  for(int i = 0 ; i < selectedDirectories.length ; i++)
                    Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(right: 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DirectoryExtractManager.dirBands.containsKey(selectedDirectories[i]) ? Center(
                            child: Container(
                              constraints: constraints,
                              child: Text(selectedDirectories[i].split("/").last.trim(), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
                            ),
                          ) : Center(
                            child: Container(
                              constraints: constraints,
                              child: Column(
                                children: [
                                  Text(HistoryManager.loadedItems.firstWhere((element) => element.date == selectedDirectories[i]).originFolder.split("/").last.trim(), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
                                  Text(HistoryManager.loadedItems.firstWhere((element) => element.date == selectedDirectories[i]).getTimeString(), style: dateStyle.copyWith(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
                                ],
                              ),
                            ),
                          ),
                          BandsTableHeaderLess(
                              bandsValues: getSelectionAverage(selectedDirectories[i]),
                              hideBands: hideBands,
                              hideNoSpec: isHideNoSpec
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            )
          ),
        ),
      )
    );
  }
}