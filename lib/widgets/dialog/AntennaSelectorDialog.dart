import 'package:flutter/material.dart';
import '../../object/object.dart';
import '../widgets.dart';

class DialogAntennaSelector extends StatefulWidget {
  final List<BandsAverage> bandList;

  const DialogAntennaSelector({
    Key? key,
    required this.bandList
  }) : super(key: key);

  @override
  State<DialogAntennaSelector> createState() => _DialogAntennaSelectorState();
}

class _DialogAntennaSelectorState extends State<DialogAntennaSelector> {

  List<String> selectedAntennas = [];

  addToList(String dir) {
    if(selectedAntennas.contains(dir)) {
      selectedAntennas.remove(dir);
    } else {
      selectedAntennas.add(dir);
    }
    setState(() {});
  }

  onPressedDone() {
    Navigator.pop(context, selectedAntennas);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12,),
              const Text("Select Antennas to display", style: TextStyle(fontSize: 18),),
              const SizedBox(height: 12,),
              for(int i = 0 ; i < widget.bandList.first.antennaDatas.length ; i++)
                if(widget.bandList.first.antennaDatas[i].data != null)
                  CheckboxListTile(
                    title: Text(widget.bandList.first.antennaDatas[i].getAntennaName()),
                    value: selectedAntennas.contains(widget.bandList.first.antennaDatas[i].antenna),
                    onChanged: (v) => addToList(widget.bandList.first.antennaDatas[i].antenna),
                  ),
              TextButton(onPressed: onPressedDone, child: const Text("Compare", style: TextStyle(color: kColor)),)
            ],
          ),
        ),
      ),
    );
  }
}