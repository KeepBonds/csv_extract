import 'package:community_charts_flutter/community_charts_flutter.dart' as chart;
import 'package:csv_extract/helper/FileHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import '../../constants/constants.dart';
import '../../helper/RandomColorGenerator.dart';
import '../../manager/manager.dart';
import '../../object/object.dart';
import '../dialog/AntennaSelectorDialog.dart';
import 'GraphColorChangerDialog.dart';

class AntennaDisplay {
  String name;
  AntennaData antennaData;

  AntennaDisplay({
    required this.name,
    required this.antennaData,
  });
}

class MultiAntennaGraphPage extends StatefulWidget {
  final List<BandsAverage> bandList;

  const MultiAntennaGraphPage({
    Key? key,
    required this.bandList
  }) : super(key: key);

  @override
  State<MultiAntennaGraphPage> createState() => _MultiAntennaGraphPageState();
}

class _MultiAntennaGraphPageState extends State<MultiAntennaGraphPage> {
  GlobalKey globalKey = GlobalKey();
  List<String> selectedAntennas = [];

  bool showLegends = true;

  List<AntennaDisplay> selectedAntennasData = [];
  List<Color> randomColorList = [];
  List<String> specsValue = [];
  List<Color> specColorList = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => showSelectAntennaDialog());
  }

  showSelectAntennaDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogAntennaSelector(
              bandList: widget.bandList
          );
        }
    ).then((value) {
      if(value != null) {
        selectedAntennas = value;
        processAntennaDatas();
        setState(() {});
      } else {
        Navigator.pop(context);
      }
    });
  }

  processAntennaDatas() {
    selectedAntennasData = getAntennaDatasFromSelection();
    randomColorList = RandomColorGenerator.generateRandomColors(selectedAntennasData.length);

    for(String antenna in selectedAntennas) {
      specColorList.add(specAntennaColor(antenna));
      specsValue.add("SPECS ${antenna} ${specValue(antenna)}");
    }
  }

  List<AntennaDisplay> getAntennaDatasFromSelection() {
    List<AntennaDisplay> selectedAntennasData = [];
    for(String antennaName in selectedAntennas) {
      for(BandsAverage bands in widget.bandList) {
        AntennaData antennaData = bands.antennaDatas.firstWhere((element) => element.antenna == antennaName);
        AntennaDisplay antennaDisplay = AntennaDisplay(
            name: "${antennaData.getAntennaName()} | ${FileHelper.getFileName(bands.directoryName)}",
            antennaData: antennaData
        );
        selectedAntennasData.add(antennaDisplay);
      }
    }
    return selectedAntennasData;
  }

  double specValue(String antenna) {
    return widget.bandList.first.bands.getSpecFromAntenna(antenna) ?? 0.0;
  }

  Color specAntennaColor(String antenna) {
    switch(antenna) {
      case "0":
        return Colors.grey.shade300;
      case "1":
        return Colors.grey.shade500;
      case "2":
        return Colors.grey.shade700;
      case "3":
        return Colors.grey.shade900;

    }
    return Colors.grey;
  }

  List<chart.Series<AntennaDataItem, double>> addSpecsSeries(List<AntennaDisplay> selectedAntennasData) {
    List<chart.Series<AntennaDataItem, double>> specsSeries = [];
    for(int i = 0 ; i < selectedAntennas.length ; i++) {
      Color specColor = specColorList[i];
      specsSeries.add(
        chart.Series(
            id: "developers",
            data: selectedAntennasData.first.antennaData.data!,
            domainFn: (AntennaDataItem series, _) => series.frequency ?? 0,
            measureFn: (AntennaDataItem series, _) => specValue(selectedAntennas[i]),
            colorFn: (AntennaDataItem series, _) => chart.Color(r: specColor.red, g: specColor.green, b: specColor.blue),
            strokeWidthPxFn: (AntennaDataItem series, _) => 0.5
        ),
      );
    }
    return specsSeries;
  }

  List<Widget> addSpecsLegends() {
    List<Widget> specsLegendList = [];
    for(int i = 0 ; i < selectedAntennas.length ; i++) {
      specsLegendList.add(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(specsValue[i], style:
            TextStyle(
                fontSize: 12,
                color: specColorList[i],
                decoration: TextDecoration.none
            ),
            ),
          )
      );
    }
    return specsLegendList;
  }

  Future<void> onTapScreenshot() async {
    String time = DateFormat("yyyyMMdd_HH_mm_ss").format(DateTime.now());
    String file = "compare_graph_$time.xlsx";

    await ScreenshotManager.saveScreenshot(globalKey, file, null);
  }

  void onTapShowLegends() {
    setState(() {
      showLegends = !showLegends;
    });
  }

  Future<void> onTapLegends() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return GraphColorChangerDialog(
            selectedAntennasData: selectedAntennasData,
            colorList: randomColorList,
            specsValue: specsValue,
            specsColor: specColorList,
          );
        }
    ).then((value) {
      if(value is List) {
        setState(() {
          randomColorList = value.first;
          specColorList = value.last;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(selectedAntennas.isEmpty) {
      return Container();
    }

    List<chart.Series<AntennaDataItem, double>> series = [];
    List<Widget> legendList = [];
    series.addAll(addSpecsSeries(selectedAntennasData));
    legendList.addAll(addSpecsLegends());

    for(int i = 0 ; i < selectedAntennasData.length ; i++) {
      chart.Color graphColor = chart.Color(r: randomColorList[i].red, g: randomColorList[i].green, b: randomColorList[i].blue);
      series.add(
        chart.Series(
            id: "developers",
            data: selectedAntennasData[i].antennaData.data!,
            domainFn: (AntennaDataItem series, _) => series.frequency ?? 0,
            measureFn: (AntennaDataItem series, _) => series.dbm,
            colorFn: (AntennaDataItem series, _) => graphColor,
            strokeWidthPxFn: (AntennaDataItem series, _) => SettingsManager.getState().graphLineWidth
        ),
      );
      legendList.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text(selectedAntennasData[i].name, style:
            TextStyle(
                fontSize: 12,
                color: randomColorList[i],
                decoration: TextDecoration.none
            ),
          ),
        )
      );
    }
    double margin = MediaQuery.of(context).size.height - MediaQuery.of(context).size.width*(9/16);
    bool isVertical = MediaQuery.of(context).orientation == Orientation.portrait;

    return InteractiveViewer(
        child: SafeArea(
          child: Stack(
            children: [
              RepaintBoundary(
                key: globalKey,
                child:
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: Container(
                        color: Colors.white,
                        margin: isVertical ? EdgeInsets.symmetric(vertical: margin/2) : EdgeInsets.zero,
                        child: chart.LineChart(
                          series,
                          primaryMeasureAxis: const chart.NumericAxisSpec(
                            viewport: chart.NumericExtents(-105.0, -85.0),
                            showAxisLine: true,
                            tickProviderSpec: chart.StaticNumericTickProviderSpec(
                                [
                                  chart.TickSpec(-90),
                                  chart.TickSpec(-95),
                                  chart.TickSpec(-100),
                                ]
                            ),
                            renderSpec: chart.GridlineRendererSpec(
                                labelStyle: chart.TextStyleSpec(
                                    fontSize: 10, //
                                    color: chart.Color.black),
                                lineStyle: chart.LineStyleSpec(thickness: 1, color: chart.Color(r: 50, g: 100, b: 50, a: 50))
                            ),
                          ),
                          domainAxis: chart.NumericAxisSpec(
                            showAxisLine: true,
                            viewport: chart.NumericExtents(selectedAntennasData.first.antennaData.data!.first.frequency!, selectedAntennasData.first.antennaData.data!.last.frequency!),
                            tickProviderSpec: const chart.BasicNumericTickProviderSpec(
                              zeroBound: false,
                              dataIsInWholeNumbers: false,
                              desiredTickCount: 8,
                            ),
                            renderSpec: const chart.GridlineRendererSpec(
                              labelStyle: chart.TextStyleSpec(
                                fontSize: 9, //
                                color: chart.Color.black,
                                lineHeight: 1.0,
                              ),
                              axisLineStyle: chart.LineStyleSpec(thickness: 1, color: chart.Color(r: 50, g: 100, b: 50, a: 50)),
                            ),
                          ),
                          selectionModels: [
                            chart.SelectionModelConfig(
                                type: chart.SelectionModelType.info,
                                updatedListener: (model) {},
                                changedListener: (chart.SelectionModel model) {}
                            )
                          ],
                          behaviors: [
                            chart.ChartTitle('MHz',
                                behaviorPosition: chart.BehaviorPosition.bottom,
                                titleStyleSpec: const chart.TextStyleSpec(fontSize: 11),
                                titleOutsideJustification: chart.OutsideJustification.middleDrawArea),
                            chart.ChartTitle('dBm',
                                behaviorPosition: chart.BehaviorPosition.start,
                                titleStyleSpec: const chart.TextStyleSpec(fontSize: 11),
                                titleOutsideJustification: chart.OutsideJustification.middleDrawArea),
                          ],
                        ), // place your chart here
                      ),
                    ),
                    if(showLegends)
                      Positioned(
                        bottom: isVertical ? 62 : 8,
                        left: 12,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onTapLegends,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: legendList,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4.0, left: 4.0),
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white,)
                ),
              ),
              Positioned(
                top: 4.0,
                right: 4.0,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: onTapShowLegends,
                      icon: Icon(showLegends ? Icons.visibility : Icons.visibility_off),
                    ),
                    IconButton(
                      onPressed: onTapScreenshot,
                      icon: downloadPngIcon(size: 22),
                    ),
                  ],
                )
              ),
            ],
          ),
        )
    );
  }
}