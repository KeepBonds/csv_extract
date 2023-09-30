import 'package:flutter/material.dart';

Future<void> showFreeAccessDialog(context) async {
  await showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: Text("NO"),
        );
      }
  );
  return;
}