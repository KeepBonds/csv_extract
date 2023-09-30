import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'MultiAntennaGraphPage.dart';

class GraphColorChangerDialog extends StatefulWidget {
  final List<AntennaDisplay> selectedAntennasData;
  final List<Color> colorList;

  final List<String> specsValue;
  final List<Color> specsColor;


  const GraphColorChangerDialog({
    Key? key,
    required this.selectedAntennasData,
    required this.colorList,
    required this.specsValue,
    required this.specsColor,
  }) : super(key: key);

  @override
  State<GraphColorChangerDialog> createState() => _GraphColorChangerDialogState();
}

class _GraphColorChangerDialogState extends State<GraphColorChangerDialog> {

  List<Color> newColors = [];
  Color pickerColor = Colors.red;

  List<Color> newSpecsColors = [];

  @override
  void initState() {
    super.initState();
    newColors.addAll(widget.colorList);
    newSpecsColors.addAll(widget.specsColor);
  }

  onColorChanged(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  onTapColorPicker(int index, bool isSpecs) {
    pickerColor = isSpecs ? newSpecsColors[index] : newColors[index];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerAreaBorderRadius: BorderRadius.circular(15.0),
                pickerColor: pickerColor,
                onColorChanged: onColorChanged,

              ),
            ),
            contentPadding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    if(isSpecs) {
                      newSpecsColors[index] = pickerColor;
                    } else {
                      newColors[index] = pickerColor;
                    }
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 8.0,),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.specsValue.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(widget.specsValue[index]),
                  trailing: Icon(Icons.circle, color: newSpecsColors[index], size: 36,),
                  onTap: () => onTapColorPicker(index, true),
                );
              },
            ),
            const Divider(),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.selectedAntennasData.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(widget.selectedAntennasData[index].name),
                  trailing: Icon(Icons.circle, color: newColors[index], size: 36,),
                  onTap: () => onTapColorPicker(index, false),
                );
              },
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text('CANCEL', style: TextStyle(color: Colors.green.shade900),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child:  Text("ACCEPT", style: TextStyle(color: Colors.green.shade900),),
                    onPressed: () {
                      Navigator.of(context).pop([newColors, newSpecsColors]);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}