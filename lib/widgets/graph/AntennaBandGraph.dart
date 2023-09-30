import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:csv_extract/object/object.dart';
import 'package:flutter/material.dart';

import '../../manager/cache/SettingsManager.dart';

// dbm / hz
class

AntennaBandGraph extends StatelessWidget {
  final List<AntennaDataItem> datas;

  const AntennaBandGraph({
    Key? key,
    required this.datas
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var greenColor = const Color(r: 50, g: 100, b: 50);

    List<Series<AntennaDataItem, double>> series = [
      Series(
          id: "developers",
          data: datas,
          domainFn: (AntennaDataItem series, _) => series.frequency ?? 0,
          measureFn: (AntennaDataItem series, _) => series.dbm,
          colorFn: (AntennaDataItem series, _) => const Color(r: 76, g: 175, b: 80),
          strokeWidthPxFn: (AntennaDataItem series, _) => SettingsManager.getState().graphLineWidth
      )
    ];

    return LineChart(
      series,
      primaryMeasureAxis: NumericAxisSpec(
        viewport: const NumericExtents(-105.0, -85.0),
        showAxisLine: true,
        tickProviderSpec: const StaticNumericTickProviderSpec(
            [
              TickSpec(-90),
              TickSpec(-95),
              TickSpec(-100),
            ]
        ),
        renderSpec: GridlineRendererSpec(
            labelStyle: const TextStyleSpec(
                fontSize: 10, //
                color: Color.black),
            lineStyle: LineStyleSpec(
                thickness: 1, color: greenColor)
        ),
      ),
      domainAxis: NumericAxisSpec(
        viewport: NumericExtents(datas.first.frequency!, datas.last.frequency!),
        tickProviderSpec: const BasicNumericTickProviderSpec(
          zeroBound: false,
          dataIsInWholeNumbers: false,
          desiredTickCount: 6,
        ),
      ),
      selectionModels: [
        SelectionModelConfig(
            type: SelectionModelType.info,
            updatedListener: (model) {},
            changedListener: (SelectionModel model) {
              String selected = "";
              //if (model.hasDatumSelection) {
              //  model.selectedDatum.forEach((SeriesDatum datumPair) {
              //    double selectedValue = datumPair.datum.weight;
              //    selected = selectedValue.toStringAsFixed(1);
              //  });
              //}
              //else {
              //  if(selectedWeeklyDatum.isNotEmpty) {
              //    selected = "";
              //  }
              //}
              //if(selectedWeeklyDatum != selected) {
              //  setState(() {
              //    selectedWeeklyDatum = selected;
              //  });
              //}
            })
      ],
      behaviors: [
        ChartTitle('MHz',
            behaviorPosition: BehaviorPosition.bottom,
            titleStyleSpec: const TextStyleSpec(fontSize: 11),
            titleOutsideJustification: OutsideJustification.middleDrawArea),
        ChartTitle('dBm',
            behaviorPosition: BehaviorPosition.start,
            titleStyleSpec: const TextStyleSpec(fontSize: 11),
            titleOutsideJustification: OutsideJustification.middleDrawArea),
      ],
    );
  }
}