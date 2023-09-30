import 'dart:io';
import 'package:csv_extract/manager/cache/HistoryManager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../object/object.dart';

class HistoryItemDialog extends StatefulWidget {
  final HistoryItem item;
  const HistoryItemDialog({Key? key, required this.item}) : super(key: key);

  @override
  State<HistoryItemDialog> createState() => _HistoryItemDialogState();
}

class _HistoryItemDialogState extends State<HistoryItemDialog> {

  Future<void> loadFile() async {
    HistoryManager.loadedItems.add(widget.item);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 55),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Image.file(File(widget.item.img)),
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            height: 55,
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.item.originFolder.split("/").last.trim()),
                    Text(DateFormat("yyyy/MM/dd HH:mm:ss").format(widget.item.parseDate()), style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),), // Display the date as the header
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
            left: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: const Icon(Icons.upload_outlined),
            onPressed: loadFile,
          ),
        ),
      ],
    );
  }
}
