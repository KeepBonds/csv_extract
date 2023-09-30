import 'dart:async';
import 'package:csv_extract/constants/constants.dart';
import 'package:flutter/material.dart';
import 'table/BandsTable.dart';
import '../manager/manager.dart';
import '../object/object.dart';

class DirectoryTile extends StatefulWidget {
  final GlobalKey globalKey;
  final ExpansionTileController expansionTileController;
  final DirectoryData directoryData;
  final bool isDownloading;

  const DirectoryTile({
    Key? key,
    required this.globalKey,
    required this.expansionTileController,
    required this.directoryData,
    this.isDownloading = false
  }) : super(key: key);

  @override
  State<DirectoryTile> createState() => _DirectoryTileState();
}

class _DirectoryTileState extends State<DirectoryTile> {
  List<BandsAverage> bandsValues = [];
  bool downloadingImage = false;

  @override
  void initState() {
    bandsValues = DirectoryExtractManager.dirBands[widget.directoryData.directory] ?? [];
    super.initState();
  }

  @override
  void didUpdateWidget(DirectoryTile oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  onTapScreenshot() async {
    setState(() {
      downloadingImage = true;
    });
    if(!widget.expansionTileController.isExpanded) {
      widget.expansionTileController.expand();
      setState(() {});
      await Future.delayed(const Duration(seconds: 2));
    }

    String parentFolder = widget.directoryData.directory.split("/").last.trim();
    ScreenshotManager.saveScreenshot(widget.globalKey, parentFolder, widget.directoryData).then((value) {
      setState(() {
        downloadingImage = false;
      });
    });
  }

  onTapExcel() async {
    ExcelCreationManager.create(context, widget.directoryData);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        controller: widget.expansionTileController,
        iconColor: Colors.black87,
        collapsedIconColor: Colors.black87,
        tilePadding: const EdgeInsets.symmetric(horizontal: 4.0),
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              child: Text(widget.directoryData.directory.split("/").last.trim(), style: const TextStyle(fontSize: 15),),
            ),),
            Row(
              children: [
                downloadingImage || widget.isDownloading ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: 20,
                  width: 20,
                  child: const CircularProgressIndicator(strokeWidth: 1.5, color: Colors.blueGrey,),
                )
                    : IconButton(
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