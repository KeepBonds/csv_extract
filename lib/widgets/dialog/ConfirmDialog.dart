import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(BuildContext context , String title ,String? desc) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title : Text(title),
        content: desc==null ? null : Text(desc, style: TextStyle(fontSize: 16),),
        actions: <Widget>[
          TextButton(
            child: Text('CANCEL', style: TextStyle(color: Colors.green.shade900),),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child:  Text("ACCEPT", style: TextStyle(color: Colors.green.shade900),),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      );
    },
  );
}