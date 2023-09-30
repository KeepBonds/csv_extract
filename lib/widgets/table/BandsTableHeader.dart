import 'package:csv_extract/manager/manager.dart';
import 'package:flutter/material.dart';

import '../graph/MultiAntennaGraphPage.dart';
import '../../manager/cache/SettingsManager.dart';
import '../../object/object.dart';

class BandsTableHeader extends StatelessWidget {
  final List<BandsAverage> bandsValues;
  final List<String>? hideBands;
  final List<List<BandsAverage>>? allBands;

  const BandsTableHeader({
    Key? key,
    required this.bandsValues,
    this.hideBands,
    this.allBands
  }) : super(key: key);

  bool hideBand(String band) => (hideBands == null || hideBands!.contains(band));
  bool hideX(BandsAverage band) => (!SettingsManager.getState().isShowX && band.antennaAverage.isEmpty);

  onOpenMultiAntennaGraph(BuildContext context, BandsAverage band) {
    if(PlanManager.isFree) return;
    if(allBands == null) return;

    List<BandsAverage> list = [];
    for(List<BandsAverage> averageList in allBands!) {
      for(BandsAverage average in averageList) {
        if(average.bands.band == band.bands.band) {
          list.add(average);
        }
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => MultiAntennaGraphPage(bandList: list)));
  }

  buildColumns() {
    List<DataColumn> column = [
      DataColumn(
        label: Container(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("LTE/NR Bands", style: SettingsManager.getState().headerStyle,),
        ),
      ),
    ];
    return column;
  }

  buildRows(BuildContext context) {
    List<DataRow> dataRows = [];
    for(int i = 0 ; i < bandsValues.length ; i++) {
      BandsAverage bandsAverage = bandsValues[i];
      if(!hideBand(bandsAverage.bands.band) && !hideX(bandsAverage)) {
        List<DataCell> cells = [];
        cells.add(buildRowTitle(context, bandsAverage));
        dataRows.add(
            DataRow(cells: cells)
        );
      }
    }
    return dataRows;
  }

  DataCell buildRowTitle(BuildContext context, BandsAverage band) {
    return DataCell(
        Container(
          padding: const EdgeInsets.only(left: 10.0, right: 6.0),
          child: Text(
            band.getRowHeaderValue(),
            style: SettingsManager.getState().headerStyle,
          ),
        ),
      onTap: () => onOpenMultiAntennaGraph(context, band)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: DataTable(
        columns: buildColumns(),
        rows: buildRows(context),
        dataRowMinHeight: SettingsManager.getState().rowHeight,
        dataRowMaxHeight: SettingsManager.getState().rowHeight,
        columnSpacing: 1.0,
        horizontalMargin: 2.0,
      ),
    );
  }
}
