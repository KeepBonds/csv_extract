import 'dart:async';
import 'dart:io';
import 'package:csv_extract/AppInfoPage.dart';
import 'package:csv_extract/ComparePage.dart';
import 'package:csv_extract/constants/constants.dart';
import 'package:csv_extract/helper/SplitModeHelper.dart';
import 'package:csv_extract/widgets/dialog/ConfirmDialog.dart';
import 'package:csv_extract/widgets/history/HistoryBottomSheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'manager/manager.dart';
import 'widgets/LoadedHistoryItemTile.dart';
import 'widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  _HomePageController createState() => _HomePageController();
}

class _HomePageController extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool loading = false;

  List<GlobalKey> globalKeys = [];
  List<bool> isDownloadingImage = [];
  List<ExpansionTileController> expansionTileControllerList = [];

  double rowHeight = kRowHeight;
  double rowWidth = kRowWidth;

  late SettingsManager settingsManager;

  Image drawerLogo = Image.asset("assets/images/ic_launcher.png", height: 250, scale: 0.5, opacity: const AlwaysStoppedAnimation(.2),);

  @override
  void initState() {
    super.initState();
    // Load settings
    settingsManager = SettingsManager.getState();
    settingsManager.loadSettings();

    // Load history
    HistoryManager.loadFromCache();

    rowHeight = settingsManager.rowHeight;
    rowWidth = settingsManager.rowWidth;
    //checkApi();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(drawerLogo.image, context);
  }

  /*
  Future<bool> initMMKV() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasVersionBeenWrong = await prefs.getBool("WRONG_VERSION") ?? true;
    return hasVersionBeenWrong;
  }

  Future<void> checkApi() async {
    bool mmkvCheck = await initMMKV();
    if(!mmkvCheck) {
      showErrorDialog();
      return;
    }

    bool apiCheck = await ApiCheck.saveInfo();
    if(!apiCheck) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("WRONG_VERSION", false);
    }

    if(!apiCheck) {
      showErrorDialog();
    }
  }

  showErrorDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Wrong version !"),
            ),
          );
        }
    );
  }
   */

  showLoading() {
    setState(() {
      loading = true;
    });
  }

  hideLoading() {
    setState(() {
      loading = false;
    });
  }

  Future<void> onSelectFolder() async {
    try{
      if(kIsWeb) {
        await DirectoryExtractManager.getDirectoryDataWeb();
      } else {
        showLoading();
        Directory? directory = await DirectoryPickerManager.getDirectory(context);

        if(directory == null) {
          hideLoading();
          return;
        }
        await DirectoryExtractManager.getDirectoryData(directory);
      }
    } catch (e) {
      showDialog(
          context: context, builder: (context) {
        return const Dialog(
          child: Text("Error while processing data"),
        );
      });
      hideLoading();
    }

    globalKeys.clear();
    isDownloadingImage.clear();
    expansionTileControllerList.clear();
    for(int i =0 ; i<DirectoryExtractManager.directoryData.length ; i++) {
      globalKeys.add(GlobalKey());
      isDownloadingImage.add(false);
      expansionTileControllerList.add(ExpansionTileController());
    }
    hideLoading();
  }

  void onPressedCompare() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ComparePage()));
  }

  void onPressedAppInfo() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AppInfoPage()));
  }

  void onPressedHistory() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        useRootNavigator: true,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const HistoryBottomSheet();
        }
    ).then((value) {
      setState(() {});
    });
  }

  expandAll() async {
    for(ExpansionTileController controller in expansionTileControllerList) {
      controller.expand();
    }
    setState(() {});
    await Future.delayed(const Duration(seconds: 2));
  }

  startDownloadUI() async {
    for(int i = 0 ; i < isDownloadingImage.length ; i++) {
      isDownloadingImage[i] = true;
    }
    setState(() {});
  }

  onDownloadAllFiles() async {
    await expandAll();
    await startDownloadUI();
    for(int i = 0 ; i < DirectoryExtractManager.directoryData.length ; i++) {
      if(globalKeys.length > i) {
        await ScreenshotManager.saveScreenshot(globalKeys[i], DirectoryExtractManager.directoryData[i].directory.split("/").last.trim(), DirectoryExtractManager.directoryData[i]);
        expansionTileControllerList[i].collapse();
        setState(() {
          isDownloadingImage[i] = false;
        });
      }
    }
  }

  onDownloadExcel() {
    try {
      for (int i = 0; i < DirectoryExtractManager.directoryData.length; i++) {
        ExcelCreationManager.create(context, DirectoryExtractManager.directoryData[i]);
      }
    } catch(e) {
      showDialog(context: context, builder: (context) {
        return Dialog(
          child: Text("Error while saving excel: $e"),
        );
      });
    }
  }

  onUpdate() {
    setState(() {
      rowHeight = settingsManager.rowHeight;
      rowWidth = settingsManager.rowWidth;
    });
  }

  Future<bool> onClickBack() async {
    bool? userAction = await showConfirmDialog(context, 'Alert', 'Are you sure you want to navigate away from this app ?');
    if (userAction ?? false) {
      await SystemChannels.platform
          .invokeMethod<void>('SystemNavigator.pop');
    } else {
      return Future.value(false);
    }
    return false;
  }


  @override
  Widget build(BuildContext context) => _HomePageView(this);
}

class _HomePageView extends WidgetView<HomePage, _HomePageController> {
  const _HomePageView(_HomePageController state) : super(state);

  Widget historyButton() {
    if(PlanManager.isFree) return Container();

    return IconButton(
        onPressed: state.onPressedHistory,
        icon: Icon(Icons.history, color: Colors.green.shade900,)
    );
  }

  Widget appInfoButton() {
    return IconButton(
        onPressed: state.onPressedAppInfo,
        icon: Icon(Icons.info_outline, color: Colors.green.shade900,)
    );
  }

  Widget searchButton() {
    if(DirectoryExtractManager.directoryData.isEmpty) return Container();

    return IconButton(
      onPressed: state.onSelectFolder,
      icon: Icon(Icons.search, color: Colors.green.shade900,),
    );
  }


  Widget downloadAllButton() {
    if (DirectoryExtractManager.directoryData.isEmpty) return Container();

    return DirectoryActionButton(
      onPressed: state.onDownloadAllFiles,
      margin: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          downloadPngIcon(size: 20),
          const SizedBox(width: 16.0,),
          const Text("Download all")
        ],
      ),
    );
  }

  Widget downloadExcelButton() {
    if (DirectoryExtractManager.directoryData.isEmpty) return Container();

    return DirectoryActionButton(
      onPressed: state.onDownloadExcel,
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          excelPngIcon(size: 21),
          const SizedBox(width: 16.0,),
          const Text("Save as Excel")
        ],
      ),
    );
  }

  Widget compareButton() {
    if (DirectoryExtractManager.directoryData.isEmpty) return Container();

    return DirectoryActionButton(
      onPressed: state.onPressedCompare,
      margin: const EdgeInsets.only(top: 12, bottom: 24),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.compare_arrows),
          SizedBox(width: 16.0,),
          Text("Compare")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: state.onClickBack,
        child: Scaffold(
          backgroundColor: Colors.white,
          key: state.scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: PlanManager.isFree ? Container() : IconButton(
              icon: const Icon(
                Icons.menu,
              ),
              onPressed: () {
                state.scaffoldKey.currentState!.openDrawer();
              },
            ),
            titleSpacing: 8,
            title: SettingsManager.getState().isShow95 ? const Tooltip(
              preferBelow: true,
              message: "\"Show 95\" settings is turned on",
              triggerMode: TooltipTriggerMode.tap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 14,),
                  Text("95", style: TextStyle(color: Colors.red, fontSize: 14),)
                ],
              ),
            ): null,
            actions: [
              historyButton(),
              appInfoButton(),
              searchButton(),
            ],
          ),
          drawer: AppDrawer(
              onUpdate: state.onUpdate
          ),
          body: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: SplitModeHelper.getMode(context) ? 700 : MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                  child: state.loading ?
                  const Center(
                    child: CircularProgressIndicator(color: Color(0xFFC8E6C9)),
                  ) :
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8.0),
                          if (DirectoryExtractManager.directoryData.isEmpty && HistoryManager.loadedItems.isEmpty) Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/5),
                            child: state.drawerLogo,
                          ),
                          if(HistoryManager.loadedItems.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(left: 4.0),
                              child: const Text("Loaded from history:", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black87, fontSize: 16),),
                            ),
                          for(int i = 0 ; i < HistoryManager.loadedItems.length ; i++)
                            LoadedHistoryItemTile(
                              globalKey: GlobalKey(),
                              historyItem: HistoryManager.loadedItems[i],
                            ),
                          if(HistoryManager.loadedItems.isNotEmpty)
                            const Divider(),
                          for(int i = 0 ; i < DirectoryExtractManager.directoryData.length ; i++)
                            DirectoryTile(
                              globalKey: state.globalKeys[i],
                              expansionTileController: state.expansionTileControllerList[i],
                              directoryData: DirectoryExtractManager.directoryData[i],
                              isDownloading: state.isDownloadingImage[i],
                            ),
                          downloadAllButton(),
                          downloadExcelButton(),
                          compareButton(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: DirectoryExtractManager.directoryData.isEmpty ? FloatingActionButton(
            foregroundColor: Colors.green.shade900,
            backgroundColor: Colors.green.shade50,
            onPressed: state.onSelectFolder,
            child: const Icon(Icons.search),
          ) : null, // This trailing comma makes auto-formatting nicer for build methods.
        ),
      );
    }
}

class DirectoryActionButton extends StatelessWidget {
  final Function() onPressed;
  final EdgeInsets? margin;
  final Widget child;

  const DirectoryActionButton({
    Key? key,
    required this.onPressed,
    this.margin,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(PlanManager.isFree) return Container();

    return Container(
      margin: margin,
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          maximumSize: Size((SplitModeHelper.getMode(context) ? 700 : MediaQuery.of(context).size.width)/2, 100),
          backgroundColor: Colors.green.shade50,
          foregroundColor: Colors.green.shade900,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
