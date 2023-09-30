import 'package:flutter/material.dart';

class ColorTemplate {
  String name;
  Color noData;
  Color noSpec;
  Color fail;
  Color marginFail;
  Color marginPass;
  Color pass;

  ColorTemplate({
    required this.name,
    required this.noData,
    required this.noSpec,
    required this.fail,
    required this.marginFail,
    required this.marginPass,
    required this.pass,
  });
}