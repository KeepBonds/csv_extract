import 'package:csv_extract/manager/cache/SettingsManager.dart';
import 'package:flutter/material.dart';
import 'ColorListTile.dart';

const kColor = Color(0xFF1B5E20);

class AppDrawer extends StatefulWidget {
  final Function() onUpdate;

  const AppDrawer({
    Key? key,
    required this.onUpdate
  }) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late SettingsManager settingsManager;

  @override
  void initState() {
    settingsManager = SettingsManager.getState();
    super.initState();
  }

  onChangedHeaderBoldType() {
    settingsManager.saveHeaderStyleBold();
    widget.onUpdate();
    setState(() {});
  }

  onChangedHeaderItalicType() {
    settingsManager.saveHeaderStyleItalic();
    widget.onUpdate();
    setState(() {});
  }

  onChangedHeaderFontSize(double size) {
    settingsManager.saveHeaderFontSize(size);
    widget.onUpdate();
    setState(() {});
  }

  onChangedBoldType() {
    settingsManager.saveValueStyleBold();
    widget.onUpdate();
    setState(() {});
  }

  onChangedItalicType() {
    settingsManager.saveValueStyleItalic();
    widget.onUpdate();
    setState(() {});
  }

  onChangedValueFontSize(double size) {
    settingsManager.saveValueFontSize(size);
    widget.onUpdate();
    setState(() {});
  }

  onChangedRowHeight(double? height) {
    if(height == null) return;
    settingsManager.saveRowHeight(height);
    widget.onUpdate();
    setState(() {});
  }

  onChangedRowWidth(double? width) {
    if(width == null) return;
    settingsManager.saveRowWidth(width);
    widget.onUpdate();
    setState(() {});
  }

  onChangedShowX() {
    settingsManager.saveShowX();
    widget.onUpdate();
    setState(() {});
  }

  onChangedShowData() {
    settingsManager.saveShowData();
    widget.onUpdate();
    setState(() {});
  }

  onChangedShow95() {
    settingsManager.saveShow95();
    widget.onUpdate();
    setState(() {});
  }

  onChangedSDLayout(StandardDeviationLayout sd) {
    settingsManager.saveStandardDeviationLayout(sd);
    widget.onUpdate();
    setState(() {});
  }

  onChangedGraphLineWidth(double? width) {
    if(width == null) return;
    settingsManager.saveGraphLineWidth(width);
    widget.onUpdate();
    setState(() {});
  }


  resetSettings() {
    settingsManager.resetSettings();
    widget.onUpdate();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 65,),
              const Text("Change Design", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              const SizedBox(height: 35,),
              Text("Row Height: ${settingsManager.rowHeight.floor()}"),
              const SizedBox(height: 8,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Slider(
                        min: 50,
                        max: 100,
                        activeColor: kColor,
                        label: settingsManager.rowHeight.toString(),
                        value: settingsManager.rowHeight,
                        onChanged: onChangedRowHeight
                    ),
                  ]
              ),
              const SizedBox(height: 28,),
              Text("Row Width: ${settingsManager.rowWidth.floor()}"),
              const SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Slider(
                      min: 60,
                      max: 100,
                      activeColor: kColor,
                      label: settingsManager.rowWidth.toString(),
                      value: settingsManager.rowWidth,
                      onChanged: onChangedRowWidth
                  ),
                ],
              ),
              const SizedBox(height: 28,),
              const Text("Header Text Style"),
              const SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 4.0),
                  Flexible(child: StyleButton(
                    isPressed: settingsManager.isHeaderBold,
                    onPressed: onChangedHeaderBoldType,
                    child: const Text("Bold", style: TextStyle(fontWeight: FontWeight.bold),),
                  )),
                  const SizedBox(width: 4.0),
                  Flexible(child: StyleButton(
                    isPressed: settingsManager.isHeaderItalic,
                    onPressed: onChangedHeaderItalicType,
                    child: const Text("Italic", style: TextStyle(fontStyle: FontStyle.italic),),
                  )),
                  const SizedBox(width: 4.0),
                  FontSizeButton(
                    initValue: SettingsManager.getState().headerFontSize,
                    onFontSizeChanged: onChangedHeaderFontSize,
                  ),
                  const SizedBox(width: 4.0),
                  // StyleButton(
                  //   isPressed: true,
                  //   onPressed: onChangedHeaderFontSize,
                  //   padding: EdgeInsets.only(left: 16, right: 4.0),
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       const Text("Size", style: TextStyle(),),
                  //       Icon(Icons.arrow_drop_down)
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 40,),
              const Text("Cell Text Style"),
              const SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 4.0),
                  Flexible(child: StyleButton(
                    isPressed: settingsManager.isValueBold,
                    onPressed: onChangedBoldType,
                    child: const Text("Bold", style: TextStyle(fontWeight: FontWeight.bold),),
                  )),
                  const SizedBox(width: 4.0),
                  Flexible(child: StyleButton(
                    isPressed: settingsManager.isValueItalic,
                    onPressed: onChangedItalicType,
                    child: const Text("Italic", style: TextStyle(fontStyle: FontStyle.italic),),
                  )),
                  const SizedBox(width: 4.0),
                  FontSizeButton(
                    initValue: SettingsManager.getState().valueFontSize,
                    onFontSizeChanged: onChangedValueFontSize,
                  ),
                  const SizedBox(width: 4.0),
                  //StyleButton(
                  //  isPressed: true,
                  //  onPressed: onChangedValueFontSize,
                  //  padding: EdgeInsets.only(left: 16, right: 4.0),
                  //  child: Row(
                  //    mainAxisSize: MainAxisSize.min,
                  //    children: [
                  //      const Text("Size", style: TextStyle(),),
                  //      Icon(Icons.arrow_drop_down)
                  //    ],
                  //  ),
                  //),
                ],
              ),
              const SizedBox(height: 40,),
              const Text("Table Design"),
              const SizedBox(height: 8,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 4.0),
                    Flexible(child: StyleButton(
                      isPressed: settingsManager.isShowX,
                      onPressed: onChangedShowX,
                      child: const Text("Show All", style: TextStyle()),
                    )),
                    const SizedBox(width: 4.0),
                    Flexible(child: StyleButton(
                      isPressed: settingsManager.isShowData,
                      onPressed: onChangedShowData,
                      child: const Text("Show Values", style: TextStyle(),),
                    )),
                  ]
              ),
              StyleButton(
                isPressed: settingsManager.isShow95,
                onPressed: onChangedShow95,
                child: const Text("Show 95", style: TextStyle(),),
              ),
              const SizedBox(height: 28,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 40,),
                  const Text("Standard Deviation"),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const StandardDeviationThresholdDialog();
                              }
                          );
                        },
                        icon: const Icon(Icons.settings_outlined, size: 18, color: Colors.grey,)
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 4.0),
                    Flexible(child: StyleButton(
                      isPressed: settingsManager.standardDeviationLayoutEnum == StandardDeviationLayout.SHOW,
                      onPressed: () => onChangedSDLayout(StandardDeviationLayout.SHOW),
                      child: const Text("Show", style: TextStyle()),
                    )),
                    const SizedBox(width: 4.0),
                    Flexible(child: StyleButton(
                      isPressed: settingsManager.standardDeviationLayoutEnum == StandardDeviationLayout.HIDE,
                      onPressed: () => onChangedSDLayout(StandardDeviationLayout.HIDE),
                      child: const Text("Hide", style: TextStyle(),),
                    )),
                    const SizedBox(width: 4.0),
                  ]
              ),
              const SizedBox(height: 40,),
              const Text("Color Template"),
              const SizedBox(height: 8,),
              ColorListTile(
                  onChanged: widget.onUpdate
              ),
              const SizedBox(height: 20,),
              Text("Graph Line Width: ${settingsManager.graphLineWidth.toStringAsFixed(1)}"),
              const SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Slider(
                      min: 0.5,
                      max: 2.0,
                      activeColor: kColor,
                      label: settingsManager.graphLineWidth.toString(),
                      value: settingsManager.graphLineWidth,
                      onChanged: onChangedGraphLineWidth
                  ),
                ],
              ),
              const SizedBox(height: 28,),
              TextButton(
                  onPressed: resetSettings,
                  child: const Text("RESET", style: TextStyle(color: kColor),)
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}

class StyleButton extends StatelessWidget {
  final Widget child;
  final bool isPressed;
  final EdgeInsets? padding;
  final Function() onPressed;

  const StyleButton({
    Key? key,
    required this.child,
    required this.isPressed,
    this.padding,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: !isPressed ? kColor : Colors.white,
        backgroundColor: isPressed ? kColor : Colors.white,
        padding: padding
      ),
      onPressed: onPressed,
      child: child
    );
  }
}

class FontSizeButton extends StatefulWidget {
  final double initValue;
  final Function(double) onFontSizeChanged;

  const FontSizeButton({
    required this.initValue,
    required this.onFontSizeChanged
  });

  @override
  _FontSizeButtonState createState() => _FontSizeButtonState();
}

class _FontSizeButtonState extends State<FontSizeButton> {
  @override
  void initState() {
    _fontSize = widget.initValue;
    super.initState();
  }

  double _fontSize = 16.0;
  final List<double> _fontSizeOptions = [12.0, 13.0, 14.0, 15.0, 16.0, 18.0, 20.0];

  void _changeFontSize(double? newSize) {
    if(newSize == null) return;
    setState(() {
      _fontSize = newSize;
      widget.onFontSizeChanged(_fontSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: const Color(0xFFF6F6FA),
      borderRadius: BorderRadius.circular(33.0),
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 4.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<double>(
            value: _fontSize,
            onChanged: _changeFontSize,
            items: _fontSizeOptions.map((double value) {
              return DropdownMenuItem<double>(
                value: value,
                child: Text('Size: $value'),
              );
            }).toList(),
            style: TextStyle(
              color: kColor,
              fontSize: _fontSize,
            ),
          ),
        ),
      ),
    );
  }
}

class StandardDeviationThresholdDialog extends StatefulWidget {
  const StandardDeviationThresholdDialog({Key? key}) : super(key: key);

  @override
  State<StandardDeviationThresholdDialog> createState() => _StandardDeviationThresholdDialogState();
}

class _StandardDeviationThresholdDialogState extends State<StandardDeviationThresholdDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: SettingsManager.getState().standardDeviationThreshold.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titleTextStyle: const TextStyle(fontSize: 18, color: Colors.black87),
      title: const Text("Standard Deviation Threshold: ", maxLines: 2,),
      contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: ((MediaQuery.of(context).size.width)/2) - 80),
      content: SizedBox(
          width: 50,
          child: TextField(
            keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
            textAlign: TextAlign.center,
            controller: controller,
          ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('CANCEL', style: TextStyle(color: Colors.green.shade900),),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child:  Text("ACCEPT", style: TextStyle(color: Colors.green.shade900),),
          onPressed: () {
            double threshold = double.tryParse(controller.text) ?? 1.0;
            SettingsManager.getState().saveStandardDeviationThreshold(threshold);
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
