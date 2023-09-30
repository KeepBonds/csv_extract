import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:csv_extract/manager/data/DirectoryExtractManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../widgets/table/BandsTable.dart';
import '../object/object.dart';

class CsvData extends StatefulWidget {
  final List<BandsAverage> bandsValues;
  const CsvData({
    Key? key,
    required this.bandsValues
  }) : super(key: key);

  @override
  State<CsvData> createState() => _CsvDataState();
}

class _CsvDataState extends State<CsvData> {
  final GlobalKey _key = GlobalKey();

  bool showValue = true;

  @override
  void initState() {
    super.initState();
  }

  onTapSwitch(bool? value) {
    if(value != null) {
      setState(() {
        showValue = value;
      });
    }
  }

  onTapScreenshot() async {
    RenderRepaintBoundary boundary = _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();

      File newFile = await File('${DirectoryExtractManager.directoryPath}image1.png').create();
      newFile.writeAsBytesSync(pngBytes);

      //File file = File.fromRawPath(pngBytes);
      //final File newImage = await file.copy('${DirectoryExtractManager.directoryPath}image1.png');

      print("SAVE " + newFile.path.toString());
    }
  }

  Widget buildDataTable() {
    return RepaintBoundary(
      key: _key,
      child: Container(
        color: Colors.white,
        child: BandsTable(
          bandsValues: widget.bandsValues,
          showValue: showValue,
          showX: false,
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
                onPressed: onTapScreenshot,
                icon: Icon(Icons.camera_alt_outlined)
            ),
            Switch(
                value: showValue,
                onChanged: onTapSwitch
            ),
            const SizedBox(width: 8.0,)
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: buildDataTable(),
          ),
        ),
    );
  }
}