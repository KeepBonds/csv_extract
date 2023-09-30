import 'dart:async';
import 'package:csv_extract/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'table/BandsTable.dart';
import '../manager/manager.dart';
import '../object/object.dart';

class LoadedHistoryItemTile extends StatefulWidget {
  final GlobalKey globalKey;
  final HistoryItem historyItem;

  const LoadedHistoryItemTile({
    Key? key,
    required this.globalKey,
    required this.historyItem
  }) : super(key: key);

  @override
  State<LoadedHistoryItemTile> createState() => _LoadedHistoryItemTileState();
}

class _LoadedHistoryItemTileState extends State<LoadedHistoryItemTile> {
  List<BandsAverage> bandsValues = [];

  @override
  void initState() {
    bandsValues = widget.historyItem.getBandsAverage();
    //bandsValues = widget.historyItem.data;
    super.initState();
  }

  @override
  void didUpdateWidget(LoadedHistoryItemTile oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  onTapScreenshot() async {
    Fluttertoast.showToast(
        msg: "DISABLED",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0
    );
    return;
    // if(!widget.expansionTileController.isExpanded) {
    //   widget.expansionTileController.expand();
    //   setState(() {});
    //   await Future.delayed(const Duration(seconds: 2));
    // }
    //
    // String parentFolder = widget.directoryData.directory.split("/").last.trim();
    // ScreenshotManager.saveScreenshot(widget.globalKey, parentFolder, widget.directoryData);
  }

  onTapExcel() async {
    Fluttertoast.showToast(
        msg: "DISABLED",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0
    );
    return;
    // ExcelCreationManager.create(widget.directoryData);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        //controller: widget.expansionTileController,
        iconColor: Colors.black87,
        collapsedIconColor: Colors.black87,
        tilePadding: const EdgeInsets.symmetric(horizontal: 4.0),
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                    child: Text(widget.historyItem.originFolder.split("/").last, style: const TextStyle(fontSize: 15),),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(widget.historyItem.getTimeString(), style: dateStyle,),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                    constraints: const BoxConstraints(),
                    onPressed: onTapScreenshot,
                    color: Colors.black87,
                    iconSize: 20,
                    icon: downloadPngIcon()
                ),
                IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                    constraints: const BoxConstraints(),
                    onPressed: onTapExcel,
                    color: Colors.black87,
                    iconSize: 20,
                    icon: excelPngIcon()
                ),
              ],
            ),
          ],
        ),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RepaintBoundary(
                key: widget.globalKey,
                child: BandsTable(
                  bandsValues: bandsValues,
                  showValue: SettingsManager.getState().isShowData,
                  showX: !SettingsManager.getState().isShowX,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}