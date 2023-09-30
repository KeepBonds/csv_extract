import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../manager/cache/HistoryManager.dart';
import '../../object/object.dart';
import 'HistoryItemDialog.dart';

class HistoryBottomSheet extends StatefulWidget {
  const HistoryBottomSheet({Key? key}) : super(key: key);

  @override
  State<HistoryBottomSheet> createState() => _HistoryBottomSheetState();
}

class _HistoryBottomSheetState extends State<HistoryBottomSheet> {

  List<HistoryItem> items = [];

  @override
  void initState() {
    items = List.from(HistoryManager.historyItems);
    items = items.reversed.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          // Note 18/12/2020 : Use of 2 InkWell as a workaround because DraggableScrollableSheet cannot be dismissed by tapping on the scrim below it's maximum extended size
          // Explanation about the DraggableScrollableSheet's UI structure: https://medium.com/flutter-community/useful-flutter-widget-draggablescrollablesheet-know-it-all-e5cc6c48528e
          child: InkWell(
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 1,
              minChildSize: 0.6,
              builder: (BuildContext context, ScrollController scrollController) {
                // avoids dismiss bottom sheet when tapping on appbar
                return InkWell(
                  child: Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.black87,
                        onPressed: () => Navigator.pop(context),
                      ),
                      elevation: 0.3,
                      backgroundColor: Colors.white,
                      title: Text("History", style: Theme.of(context).textTheme.titleLarge,),
                      centerTitle: true,
                    ),
                    body: SafeArea(
                      bottom: false,
                      right: true,
                      top: false,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            items.isNotEmpty ?
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final HistoryItem item = items[index];
                                  final HistoryItem? previousItem = index > 0 ? items[index - 1] : null;
                                  final bool isDifferentDay = previousItem == null ||
                                      item.getDay() != previousItem.getDay();

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (isDifferentDay) DateSeparator(item: item,),
                                      HistoryItemTile(item: item,),
                                    ],
                                  );
                                }) : Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text("No data in history", style: Theme.of(context).textTheme.bodyMedium)
                                  ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {},
                );
              },
            ),
            onTap: () => Navigator.pop(context),
          )
      ),
    );
  }
}

class DateSeparator extends StatelessWidget {
  final HistoryItem item;

  const DateSeparator({
    Key? key,
    required this.item
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: const Color(0xffF1F1F1),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Text(DateFormat("dd MMM yyyy").format(item.parseDate()), style: TextStyle(fontStyle: FontStyle.italic),),
    );
  }
}

class HistoryItemTile extends StatelessWidget {
  final HistoryItem item;

  const HistoryItemTile({
    Key? key,
    required this.item
  }) : super(key: key);

  onTapItem(BuildContext context, HistoryItem item) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Card(
            margin: EdgeInsets.all(12.0),
              clipBehavior: Clip.antiAlias,
              borderOnForeground: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              child: HistoryItemDialog(item: item)
          );
        }
    ).then((value) {
      if(value is bool && value) {
        Navigator.pop(context);
      }
    });
  }

  Widget image() {
    return Container(
      width: 55,
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            alignment: FractionalOffset.center,
            image: FileImage(File(item.img)),
          ),
          shape:  BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: ListTile(
        title: Text(item.originFolder.split("/").last.trim()),
        subtitle: Text(DateFormat("yyyy/MM/dd HH:mm:ss").format(item.parseDate()), style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),), // Display the date as the header
        leading: image(),
        onTap: () => onTapItem(context, item),// Display the small picture
      ),
    );
  }
}

