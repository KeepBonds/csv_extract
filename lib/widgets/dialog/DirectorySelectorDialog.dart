import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../manager/manager.dart';
import '../widgets.dart';

class DirectorySelectorDialog extends StatefulWidget {
  const DirectorySelectorDialog({Key? key}) : super(key: key);

  @override
  State<DirectorySelectorDialog> createState() => _DirectorySelectorDialogState();
}

class _DirectorySelectorDialogState extends State<DirectorySelectorDialog> {

  List<String> selectedDirectories = [];

  addToList(String dir) {
    if(selectedDirectories.contains(dir)) {
      selectedDirectories.remove(dir);
    } else {
      selectedDirectories.add(dir);
    }
    setState(() {});
  }

  onPressedDone() {
    Navigator.pop(context, selectedDirectories);
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
              const Text("Select directories to compare", style: TextStyle(fontSize: 18),),
              const SizedBox(height: 12,),
              for(int i = 0 ; i < DirectoryExtractManager.directoryData.length ; i++)
                ListTile(
                  title: Text(DirectoryExtractManager.directoryData[i].directory.split("/").last.trim()),
                  selected: selectedDirectories.contains(DirectoryExtractManager.directoryData[i].directory),
                  selectedColor: Colors.white,
                  selectedTileColor: kColor,
                  onTap: () => addToList(DirectoryExtractManager.directoryData[i].directory),
                ),
              if(HistoryManager.loadedItems.isNotEmpty && DirectoryExtractManager.directoryData.isNotEmpty) Divider(),
              for(int i = 0 ; i < HistoryManager.loadedItems.length ; i++)
                ListTile(
                  title: Text(HistoryManager.loadedItems[i].originFolder.split("/").last.trim()),
                  subtitle: Text(HistoryManager.loadedItems[i].getTimeString(), style: dateStyle,),
                  selected: selectedDirectories.contains(HistoryManager.loadedItems[i].date),
                  selectedColor: Colors.white,
                  selectedTileColor: kColor,
                  onTap: () => addToList(HistoryManager.loadedItems[i].date),
                ),
              TextButton(onPressed: onPressedDone, child: const Text("Compare", style: TextStyle(color: kColor)),)
            ],
          ),
        ),
      ),
    );
  }
}
