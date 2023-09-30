import 'package:csv_extract/manager/cache/SettingsManager.dart';
import 'package:csv_extract/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../manager/manager.dart';
import '../graph/MultiAntennaGraphPage.dart';
import '../../object/object.dart';

class BandsTable extends StatefulWidget {
  final List<BandsAverage> bandsValues;
  final bool showValue;
  final bool showX;
  final List<int>? hideIndex;

  const BandsTable({
    Key? key,
    required this.bandsValues,
    required this.showValue,
    required this.showX,
    this.hideIndex,
  }) : super(key: key);


  @override
  State<BandsTable> createState() => _BandsTableState();
}

class _BandsTableState extends State<BandsTable> {

  onOpenMultiAntennaGraph(BandsAverage band) {
    if(PlanManager.isFree) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => MultiAntennaGraphPage(bandList: [band])));
  }

  buildColumns() {
    List<DataColumn> column = [
      DataColumn(
        label: Container(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("LTE/NR Bands", style: SettingsManager.getState().headerStyle,),
        ),
      ),
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
    List<DataRow> dataRows = [];
    for(int i = 0 ; i < widget.bandsValues.length ; i++) {
      BandsAverage band = widget.bandsValues[i];

      if(!(widget.showX && band.antennaAverage.isEmpty) && (widget.hideIndex == null || !widget.hideIndex!.contains(i))) {
        List<DataCell> cells = [];
        cells.add(buildRowTitle(band));
        cells.add(buildAntenna(band, "0"));
        cells.add(buildAntenna(band, "1"));
        cells.add(buildAntenna(band, "2"));
        cells.add(buildAntenna(band, "3"));
        dataRows.add(
            DataRow(cells: cells)
        );
      }
    }
    return dataRows;
  }

  DataCell buildRowTitle(BandsAverage band) {
    return DataCell(
        Container(
          padding: const EdgeInsets.only(left: 10.0, right: 6.0),
          child: Text(
              "${band.bands.band} - ${band.fileFrequency ?? band.bands.frequency}, ${band.bands.otherData}",
                  style: SettingsManager.getState().headerStyle,
          ),
        ),
      onTap: () => onOpenMultiAntennaGraph(band),
    );
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
