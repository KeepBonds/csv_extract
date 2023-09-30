import 'package:csv_extract/manager/manager.dart';
import 'package:flutter/material.dart';

import '../../constants/ColorTemplateConst.dart';
import '../../object/ColorTemplate.dart';
import 'AppDrawer.dart';
import 'ColorSelectDialog.dart';

class ColorListTile extends StatefulWidget {
  final Function() onChanged;

  const ColorListTile({
    Key? key,
    required this.onChanged
  }) : super(key: key);

  @override
  State<ColorListTile> createState() => _ColorListTileState();
}

class _ColorListTileState extends State<ColorListTile> {
  late ColorTemplate colorTemplate;

  @override
  void initState() {
    colorTemplate = SettingsManager.getState().template ?? defaultTemplate;
    super.initState();
  }

  Widget colorWidget(Color color) {
    return Material(
      //borderRadius: BorderRadius.circular(15),
        color: color,
        child: const SizedBox(
          height: 26,
          width: 26,
        )
    );
  }

  Widget textWidget(String text) {
    return Text(text, style: const TextStyle(color: Colors.black, fontSize: 10), maxLines: 2,);
  }

  onPressed() {
    showDialog(
        context: context,
        builder: (context) {
          return const ColorSelectDialog();
        }
    ).then((value) {
      colorTemplate = SettingsManager.getState().template ?? defaultTemplate;
      widget.onChanged();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: Text(colorTemplate.name, style: TextStyle(color: kColor),)),
              colorWidget(colorTemplate.pass),
              colorWidget(colorTemplate.marginPass),
              colorWidget(colorTemplate.marginFail),
              colorWidget(colorTemplate.fail),
              colorWidget(colorTemplate.noData),
              colorWidget(colorTemplate.noSpec),
            ],
          )
      ),
    );
  }
}