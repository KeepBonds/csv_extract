import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import '../../constants/ColorTemplateConst.dart';
import '../../manager/manager.dart';
import '../../object/object.dart';
import '../graph/AntennaBandGraph.dart';

class BandsTableCell extends StatelessWidget {
  final BandsAverage band;
  final String antennaNumber;

  const BandsTableCell({
    Key? key,
    required this.band,
    required this.antennaNumber
  }) : super(key: key);

  Widget dataCell(AntennaAverage antenna, AntennaData? datas, double spec) {
    double difference = spec - antenna.average!;
    Color color = getColor(difference);

    if(SettingsManager.getState().isShowData) {
      return SizedBox.expand(
        child: Container(
          color: color.withOpacity(0.7),
          child: BandsTableCellStructure(
            antennaData: datas,
            child: Text(antenna.average!.toStringAsFixed(1), style: SettingsManager.getState().valueStyle),
          ),
        ),
      );
    }

    String value = difference > 1 ? "PASS" : difference.toStringAsFixed(1);
    // To avoid confusion, we avoid displaying 0.0 and -0.0,
    // so we round it to the above value only in those case
    if(value == "0.0") {
      value = "0.1";
    }
    if(value == "-0.0") {
      value = "-0.1";
    }

    return SizedBox.expand(
      child: Container(
        color: color,
        child: BandsTableCellStructure(
          child: Text(value, style: SettingsManager.getState().valueStyle,),
          antennaData: datas,
          band: band,
          antennaNumber: antennaNumber,
        ),
      ),
    );
  }

  Widget specNotFoundCell() {
    ColorTemplate colorTemplate =  (SettingsManager.getState().template?? defaultTemplate);

    Widget baseWidget = BandsTableCellStructure(
      child: Text("/", style: SettingsManager.getState().valueStyle,),
    );

    if(SettingsManager.getState().isShowData) {
      return  Container(
        color: colorTemplate.noSpec.withOpacity(0.1),
        child: baseWidget,
      );
    }
    return SizedBox.expand(
      child: Container(
        color: colorTemplate.noSpec,
        child: baseWidget,
      ),
    );
  }

  Widget dataNotFoundCell() {
    ColorTemplate colorTemplate =  (SettingsManager.getState().template?? defaultTemplate);

    Widget baseWidget = BandsTableCellStructure(
      child: Text("X", style: SettingsManager.getState().valueStyle),
    );

    if(SettingsManager.getState().isShowData) {
      return SizedBox.expand(
        child: Container(
          color: colorTemplate.noData.withOpacity(0.1),
          child: baseWidget,
        ),
      );
    }

    return SizedBox.expand(
      child: Container(
        color: colorTemplate.noData,
        child: baseWidget,
      ),
    );
  }


//    if(difference > 1) => pass // x < spec-1 | ie below -96
//    if(difference > 0)  => margin pass // spec-1 < x < spec | ie between -96 & -95
//    if(difference > -1) => margin fail // spec < x < spec+1 | ie between -95 & -94
//    if(above x > spec+1) => fail | ie -94
  Color getColor(double difference) {
    ColorTemplate colorTemplate =  (SettingsManager.getState().template?? defaultTemplate);
    if(difference > 1) { // x < spec-1 | ie below -96
      return colorTemplate.pass;
    }
    if(difference > 0) { // spec-1 < x < spec | ie between -96 & -95
      return colorTemplate.marginPass;
    }
    if(difference > -1) { // spec < x < spec+1 | ie between -95 & -94
      return colorTemplate.marginFail;
    }
    // above x > spec+1 | ie -94
    return colorTemplate.fail;
  }

  AntennaAverage? findAntenna(BandsAverage band, String antenna) {
    for(AntennaAverage antennaAverage in band.antennaAverage) {
      if(antennaAverage.antenna == antenna) {
        return antennaAverage;
      }
    }
    return null;
  }

  AntennaData? getAntennaData(BandsAverage band, String antenna) {
    for(AntennaData antennaData in band.antennaDatas) {
      if(antennaData.antenna == antenna) {
        return antennaData;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double? spec = band.bands.getSpecFromAntenna(antennaNumber);
    if(spec == null) return specNotFoundCell();

    AntennaAverage? antenna = findAntenna(band, antennaNumber);
    AntennaData? datas = getAntennaData(band, antennaNumber);

    if(band.antennaAverage.isEmpty || antenna?.average == null) return dataNotFoundCell();

    return dataCell(antenna!, datas, spec);
  }
}

class BandsTableCellStructure extends StatelessWidget {
  final Widget child;
  final AntennaData? antennaData;
  final BandsAverage? band;
  final String? antennaNumber;

  const BandsTableCellStructure({
    Key? key,
    required this.child,
    this.antennaData,
    this.band,
    this.antennaNumber
  }) : super(key: key);

  String getAntennaName(String antenna) {
      String? name;
      switch(antenna) {
        case "0":
          name = "MAIN, Ant5";
        case "1":
          name = "AUX1, Ant6";
        case "2":
          name = "AUX2, Ant7";
        case "3":
          name = "AUX3, Ant8";
      }
      return name ?? "";
  }

  double getSD() {
    List<double> dbmList = [];
    antennaData!.data!.forEach((element) {
      if(element.dbm != null) {
        dbmList.add(element.dbm!);
      }
    });
    return IdentifyPeaksManager.calculateStandardDeviation(dbmList);
  }

  @override
  Widget build(BuildContext context) {
    if(antennaData == null || band == null || antennaNumber == null) {
      return SizedBox(
        width:  SettingsManager.getState().rowWidth,
        child: Center(
          child: child,
        ),
      );
    }

    double sd = getSD();
    double threshold = 1.0;
    bool isAbove = threshold < sd;

    return OpenContainer(
      tappable: !PlanManager.isFree,
      openColor: Colors.black,
      closedElevation: 0.0,
      closedColor: Colors.transparent,
        closedBuilder: (context, close) {
          return SizedBox(
            width:  SettingsManager.getState().rowWidth,
            child: Stack(
              children: [
                Center(
                    child: child
                ),
                if(isAbove && SettingsManager.getState().standardDeviationLayoutEnum == StandardDeviationLayout.SHOW)
                  const Positioned(
                    top: 2,
                    right: 2,
                    child: Icon(Icons.sd, color: Colors.black26, size: 12.0,),
                  ),
              ],
            )
          );
        },
        openBuilder: (context, open) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width;
            double margin = height > width ? height - width*(9/16) : 1;
            return SafeArea(
              child: Stack(
                children: [
                  InteractiveViewer(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                        child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: margin/2),
                          child: AntennaBandGraph(datas: antennaData!.data!), // place your chart here
                        ),
                      )
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Text(band!.getRowHeaderValue(), style: const TextStyle(color: Colors.white, fontSize: 16),),
                        Text(getAntennaName(antennaNumber!), style: const TextStyle(color: Colors.white54, fontSize: 14),),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4.0, left: 4.0),
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white,)
                    ),
                  )
                ],
              ),
            );
          }
    );
  }
}