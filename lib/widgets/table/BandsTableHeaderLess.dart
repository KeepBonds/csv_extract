import 'package:csv_extract/manager/cache/SettingsManager.dart';
import 'package:csv_extract/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../object/object.dart';

class BandsTableHeaderLess extends StatelessWidget {
  final List<BandsAverage> bandsValues;
  final List<String>? hideBands;
  final bool? hideNoSpec;

  const BandsTableHeaderLess({
    Key? key,
    required this.bandsValues,
    this.hideBands,
    this.hideNoSpec
  }) : super(key: key);

  bool hideIndex(String band) => (hideBands == null || hideBands!.contains(band));
  bool hideX(BandsAverage band) => (!SettingsManager.getState().isShowX && band.antennaAverage.isEmpty);

  buildColumns() {
    bool hideNoSpecColumn = hideNoSpec ?? false;

    List<DataColumn> column = [
      DataColumn(
        label: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text("MAIN", style: SettingsManager.getState().headerStyle),
              ),
              Flexible(
                child: Text("Ant5", style: SettingsManager.getState().headerStyle),
              ),
            ],
          ),
        ),
      ),
      DataColumn(
          label: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text("AUX1", style: SettingsManager.getState().headerStyle),
                  ),
                  Flexible(
                    child: Text("Ant6", style: SettingsManager.getState().headerStyle),
                  ),
                ],
              )
          )
      ),
      if(!hideNoSpecColumn)
        DataColumn(
            label: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text("AUX2", style: SettingsManager.getState().headerStyle),
                  ),
                  Flexible(
                    child: Text("Ant7", style: SettingsManager.getState().headerStyle),
                  ),
                ],
              ),
            )
        ),
      if(!hideNoSpecColumn)
        DataColumn(
          label: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text("AUX3", style: SettingsManager.getState().headerStyle),
                ),
                Flexible(
                  child: Text("Ant8", style: SettingsManager.getState().headerStyle),
                ),
              ],
            ),
          ),
        ),
    ];
    return column;
  }

  buildRows() {
    bool hideNoSpecColumn = hideNoSpec ?? false;

    List<DataRow> dataRows = [];
    for(int i = 0 ; i < bandsValues.length ; i++) {
      BandsAverage bandsAverage = bandsValues[i];
      if(!hideIndex(bandsAverage.bands.band) && !hideX(bandsAverage)) {
        List<DataCell> cells = [];
        cells.add(buildAntenna(bandsAverage, "0"));
        cells.add(buildAntenna(bandsAverage, "1"));
        if(!hideNoSpecColumn) {
          cells.add(buildAntenna(bandsAverage, "2"));
          cells.add(buildAntenna(bandsAverage, "3"));
        }
        dataRows.add(
            DataRow(cells: cells)
        );
      }
    }
    return dataRows;
  }

  DataCell buildAntenna(BandsAverage band, String antennaNumber) {
    return DataCell(
        BandsTableCell(
          band: band,
          antennaNumber: antennaNumber,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: DataTable(
        columns: buildColumns(),
        rows: buildRows(),
        dataRowMinHeight: SettingsManager.getState().rowHeight,
        dataRowMaxHeight: SettingsManager.getState().rowHeight,
        columnSpacing: 1.0,
        horizontalMargin: 2.0,
      ),
    );
  }
}
