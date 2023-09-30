import 'package:csv_extract/manager/data/BandsManager.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'manager/PlanManager.dart';

class AppInfoPage extends StatefulWidget {
  const AppInfoPage({Key? key}) : super(key: key);

  @override
  State<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  Image drawerLogo = Image.asset("assets/images/ic_launcher.png", height: 150,);

  String appVersion = "";
  String appName = "";

  TextStyle headerStyle = const TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
  TextStyle dataStyle = const TextStyle(fontSize: 13, fontWeight: FontWeight.normal);

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = packageInfo.version;
      appName = packageInfo.appName;
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(drawerLogo.image, context);
  }

  buildColumns() {
    List<DataColumn> column = [
      DataColumn(
        label: Container(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("LTE/NR Bands", style: headerStyle,),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text("MAIN", style: headerStyle),
              ),
              Flexible(
                child: Text("Ant5", style: headerStyle),
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
                    child: Text("AUX1", style: headerStyle),
                  ),
                  Flexible(
                    child: Text("Ant6", style: headerStyle),
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
                  child: Text("AUX2", style: headerStyle),
                ),
                Flexible(
                  child: Text("Ant7", style: headerStyle),
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
                child: Text("AUX3", style: headerStyle),
              ),
              Flexible(
                child: Text("Ant8", style: headerStyle),
              ),
            ],
          ),
        ),
      ),
    ];
    return column;
  }

  buildRows() {
    print("LENGTH: " + BandsManager.bands.length.toString());
    List<DataRow> dataRows = [];
    for(int i = 0 ; i < BandsManager.bands.length ; i++) {
        List<DataCell> cells = [];
        cells.add(DataCell(Text("${BandsManager.bands[i].band}  - ${BandsManager.bands[i].frequency}\n${BandsManager.bands[i].otherData}", style: headerStyle,)),);
        cells.add(dataCell("${BandsManager.bands[i].specAntenna1 ?? "/"}"));
        cells.add(dataCell("${BandsManager.bands[i].specAntenna2 ?? "/"}"));
        cells.add(dataCell("${BandsManager.bands[i].specAntenna3 ?? "/"}"));
        cells.add(dataCell("${BandsManager.bands[i].specAntenna4 ?? "/"}"));
        dataRows.add(
            DataRow(cells: cells)
        );
    }
    return dataRows;
  }

  DataCell dataCell(String text) {
    return DataCell(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        alignment: Alignment.center,
        child: Text(text, style: dataStyle),
      ),
    );
  }

  onPressedSpecs() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width-16,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: DataTable(
                  columns: buildColumns(),
                  rows: buildRows(),
                  //dataRowMinHeight: SettingsManager.getState().rowHeight,
                  //dataRowMaxHeight: SettingsManager.getState().rowHeight,
                  columnSpacing: 1.0,
                  horizontalMargin: 2.0,
                ),
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(appName, style: Theme.of(context).textTheme.headlineSmall,),
              const SizedBox(height: 4.0,),
              Text("Version $appVersion", style: Theme.of(context).textTheme.bodyMedium,),
              const SizedBox(height: 24.0,),
              drawerLogo,
              const SizedBox(height: 32.0,),
              if(!PlanManager.isFree) TextButton(
                onPressed: onPressedSpecs,
                child: const Text("Specs"),
              ),
              const SizedBox(height: 65.0,),
            ],
          ),
        ),
    );
  }
}
