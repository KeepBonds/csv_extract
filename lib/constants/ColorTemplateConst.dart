import 'package:csv_extract/object/ColorTemplate.dart';
import 'package:flutter/material.dart';

ColorTemplate defaultTemplate = ColorTemplate(
    name: "Default",
    noData: Colors.black26,
    noSpec: Colors.white,
    fail: Colors.red,
    marginFail: Colors.yellow,
    marginPass: Colors.green.shade100,
    pass: Colors.green
);

ColorTemplate blindColorTemplate = ColorTemplate(
    name: "BlindColor",
    noData: Colors.black26,
    noSpec: Colors.white,
    fail: Color(0xffDC267F),
    marginFail: Color(0xffFFB000),
    marginPass: Color(0x77648FFF),
    pass: Color(0xff648FFF)
);


ColorTemplate blindColorTemplate2 = ColorTemplate(
    name: "BlindColor2",
    noData: Colors.black26,
    noSpec: Colors.white,
    fail: Colors.pinkAccent,
    marginFail: Colors.pinkAccent.shade100,
    marginPass: Colors.blue.shade100,
    pass: Colors.blue.shade300
);

ColorTemplate whiteTemplate = ColorTemplate(
    name: "White",
    noData: Colors.white,
    noSpec: Colors.white,
    fail: Colors.white,
    marginFail: Colors.white,
    marginPass: Colors.white,
    pass: Colors.white
);