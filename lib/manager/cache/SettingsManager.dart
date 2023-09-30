import 'package:csv_extract/object/ColorTemplate.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../manager.dart';

const double kHeaderFontSize = 15.0;
const double kFontSize = 14.0;
const double kRowHeight = 50.0;
const double kRowWidth = 60.0;
const double kStandardDeviationThreshold = 1.0;
const double kGraphLineWidth = 0.5;

enum StandardDeviationLayout {
  HIDE,
  SHOW,
}

class SettingsManager {
  static SettingsManager? _manager;

  TextStyle get headerStyle {
    return TextStyle(
        fontSize: headerFontSize,
        fontWeight: isHeaderBold ? FontWeight.bold : FontWeight.normal,
        fontStyle: isHeaderItalic ? FontStyle.italic : FontStyle.normal
    );
  }

  TextStyle get valueStyle {
    return TextStyle(
        fontSize: valueFontSize,
        fontWeight: isValueBold ? FontWeight.bold : FontWeight.normal,
        fontStyle: isValueItalic ? FontStyle.italic : FontStyle.normal
    );
  }

  double _rowHeight = kRowHeight;
  double get rowHeight => _rowHeight;

  double _rowWidth = kRowWidth;
  double get rowWidth => _rowWidth;

  bool _isHeaderBold = false;
  bool get isHeaderBold => _isHeaderBold;

  bool _isHeaderItalic = false;
  bool get isHeaderItalic => _isHeaderItalic;

  double _headerFontSize = kHeaderFontSize;
  double get headerFontSize => _headerFontSize;

  bool _isValueBold = false;
  bool get isValueBold => _isValueBold;

  bool _isValueItalic = false;
  bool get isValueItalic => _isValueItalic;

  double _valueFontSize = kFontSize;
  double get valueFontSize => _valueFontSize;

  bool _isShowX = false;
  bool get isShowX => PlanManager.isFree ? true : _isShowX;

  bool _isShowData = false;
  bool get isShowData => PlanManager.isFree ? true : _isShowData;

  bool _isShow95 = false;
  bool get isShow95 => _isShow95;

  ColorTemplate? _template;
  ColorTemplate? get template => PlanManager.isFree ? whiteTemplate: _template;

  double _standardDeviationThreshold = kStandardDeviationThreshold;
  double get standardDeviationThreshold => _standardDeviationThreshold;

  StandardDeviationLayout _standardDeviationLayout = StandardDeviationLayout.SHOW;
  StandardDeviationLayout get standardDeviationLayoutEnum => PlanManager.isFree ? StandardDeviationLayout.HIDE: _standardDeviationLayout;

  double _graphLineWidth = kGraphLineWidth;
  double get graphLineWidth => _graphLineWidth;

  SettingsManager._internal() {
    _rowWidth = kRowWidth;
    _rowHeight = kRowHeight;
    _isHeaderBold = false;
    _isHeaderItalic = false;
    _isValueBold = false;
    _isValueItalic = false;
    _headerFontSize = kHeaderFontSize;
    _valueFontSize = kFontSize;
    _isShowX = false;
    _isShowData = false;
    _isShow95 = false;
    _template = null;
    _standardDeviationThreshold = kStandardDeviationThreshold;
    _standardDeviationLayout = StandardDeviationLayout.SHOW;
    _graphLineWidth = kGraphLineWidth;
  }

  static SettingsManager getState() {
    return _manager ??= SettingsManager._internal();
  }

  void reset() {
    _rowHeight = kRowHeight;
    _rowWidth = kRowWidth;
    _isHeaderBold = false;
    _isHeaderItalic = false;
    _isValueBold = false;
    _isValueItalic = false;
    _headerFontSize = kHeaderFontSize;
    _valueFontSize = kFontSize;
    _isShowX = false;
    _isShowData = false;
    _isShow95 = false;
    _template = null;
    _standardDeviationThreshold = kStandardDeviationThreshold;
    _standardDeviationLayout = StandardDeviationLayout.SHOW;
    _graphLineWidth = kGraphLineWidth;
  }

  resetSettings() {
    saveRowHeight(kRowHeight);
    saveRowWidth(kRowWidth);
    _isHeaderBold = true;
    _isHeaderItalic = true;
    saveHeaderStyleBold();
    saveHeaderStyleItalic();
    saveHeaderFontSize(kHeaderFontSize);
    _isValueBold = true;
    _isValueItalic = true;
    saveValueStyleBold();
    saveValueStyleItalic();
    saveValueFontSize(kFontSize);
    _isShowX = true;
    _isShowData = true;
    _isShow95 = true;
    saveShowX();
    saveShowData();
    saveShow95();
    saveColorTemplate(defaultTemplate);
    saveStandardDeviationLayout(StandardDeviationLayout.SHOW);
    saveStandardDeviationThreshold(kStandardDeviationThreshold);
    saveGraphLineWidth(kGraphLineWidth);

  }

  loadRowHeight() async {
    _rowHeight = await CacheManager.getDouble(StorageKey.ROW_HEIGHT, defaultValue: kRowHeight) ?? kRowHeight;
  }

  saveRowHeight(double height) async {
    _rowHeight = height;
    await CacheManager.setDouble(StorageKey.ROW_HEIGHT, _rowHeight);
  }

  loadRowWidth() async {
    _rowWidth = await CacheManager.getDouble(StorageKey.ROW_WIDTH, defaultValue: kRowWidth) ?? kRowWidth;
  }

  saveRowWidth(double width) async {
    _rowWidth = width;
    await CacheManager.setDouble(StorageKey.ROW_WIDTH, _rowWidth);
  }

  loadHeaderStyle() async {
    _isHeaderBold = await CacheManager.getBool(StorageKey.HEADER_STYLE_BOLD) ?? false;
    _isHeaderItalic = await CacheManager.getBool(StorageKey.HEADER_STYLE_ITALIC) ?? false;
    _headerFontSize = await CacheManager.getDouble(StorageKey.HEADER_FONT_SIZE, defaultValue: kHeaderFontSize) ?? kHeaderFontSize;
  }

  saveHeaderStyleBold() async {
    _isHeaderBold = !_isHeaderBold;
    await CacheManager.setBool(StorageKey.HEADER_STYLE_BOLD, _isHeaderBold);
  }

  saveHeaderStyleItalic() async {
    _isHeaderItalic = !_isHeaderItalic;
    await CacheManager.setBool(StorageKey.HEADER_STYLE_ITALIC, _isHeaderItalic);
  }

  saveHeaderFontSize(double fontSize) async {
    _headerFontSize = fontSize;
    await CacheManager.setDouble(StorageKey.HEADER_FONT_SIZE, _headerFontSize);
  }

  loadValueStyle() async {
    _isValueBold = await CacheManager.getBool(StorageKey.VALUE_STYLE_BOLD) ?? false;
    _isValueItalic = await CacheManager.getBool(StorageKey.VALUE_STYLE_ITALIC) ?? false;
    _valueFontSize = await CacheManager.getDouble(StorageKey.VALUE_FONT_SIZE, defaultValue: kFontSize) ?? kFontSize;
  }

  saveValueStyleBold() async {
    _isValueBold = !_isValueBold;
    await CacheManager.setBool(StorageKey.VALUE_STYLE_BOLD, _isValueBold);
  }

  saveValueStyleItalic() async {
    _isValueItalic = !_isValueItalic;
    await CacheManager.setBool(StorageKey.VALUE_STYLE_ITALIC, _isValueItalic);
  }

  saveValueFontSize(double fontSize) async {
    _valueFontSize = fontSize;
    await CacheManager.setDouble(StorageKey.VALUE_FONT_SIZE, _valueFontSize);
  }

  loadTableDesign() async {
    _isShowX = await CacheManager.getBool(StorageKey.SHOW_X) ?? false;
    _isShowData = await CacheManager.getBool(StorageKey.SHOW_DATA) ?? false;
    _isShow95 = await CacheManager.getBool(StorageKey.SHOW_95) ?? false;
  }

  saveShowX() async {
    _isShowX = !_isShowX;
    await CacheManager.setBool(StorageKey.SHOW_X, _isShowX);
  }

  saveShowData() async {
    _isShowData = !_isShowData;
    await CacheManager.setBool(StorageKey.SHOW_DATA, _isShowData);
  }

  saveShow95() async {
    _isShow95 = !_isShow95;
    await CacheManager.setBool(StorageKey.SHOW_DATA, _isShow95);
  }

  loadColorTemplate() async {
    String? templateString = await CacheManager.getString(StorageKey.COLOR_TEMPLATE);
    _template = [defaultTemplate, blindColorTemplate, blindColorTemplate2, whiteTemplate].firstWhere((element) => element.name == templateString, orElse: () => defaultTemplate);
  }

  saveColorTemplate(ColorTemplate colorTemplate) async {
    _template = colorTemplate;
    String? templateString = colorTemplate.name;
    await CacheManager.setString(StorageKey.COLOR_TEMPLATE, templateString);
  }

  loadStandardDeviationThreshold() async {
    _standardDeviationThreshold = await CacheManager.getDouble(StorageKey.STANDARD_DEVIATION_THRESHOLD, defaultValue: 1.0) ?? kStandardDeviationThreshold;
  }

  saveStandardDeviationThreshold(double sd) async {
    _standardDeviationThreshold = sd;
    await CacheManager.setDouble(StorageKey.STANDARD_DEVIATION_THRESHOLD, _standardDeviationThreshold);
  }

  StandardDeviationLayout mapStringToEnum(String value) {
    switch (value) {
      case "HIDE":
        return StandardDeviationLayout.HIDE;
      case "SHOW":
      default:
        return StandardDeviationLayout.SHOW;
    }
  }

  Future<void> loadStandardDeviationLayout() async {
    String _standardDeviationLayoutString = await CacheManager.getString(StorageKey.STANDARD_DEVIATION_LAYOUT);
    _standardDeviationLayout = mapStringToEnum(_standardDeviationLayoutString);
  }

  Future<void> saveStandardDeviationLayout(StandardDeviationLayout sd) async {
    _standardDeviationLayout = sd;
    await CacheManager.setString(StorageKey.STANDARD_DEVIATION_LAYOUT, _standardDeviationLayout.toString().split('.').last);
  }

  Future<void> loadGraphLineWidth() async {
    _graphLineWidth = await CacheManager.getDouble(StorageKey.GRAPH_LINE_WIDTH, defaultValue: kGraphLineWidth) ?? kGraphLineWidth;
  }

  Future<void> saveGraphLineWidth(double width) async {
    _graphLineWidth = width;
    await CacheManager.setDouble(StorageKey.GRAPH_LINE_WIDTH, _graphLineWidth);
  }


  loadSettings() async {
    await loadRowHeight();
    await loadRowWidth();
    await loadHeaderStyle();
    await loadValueStyle();
    await loadTableDesign();
    await loadColorTemplate();
    await loadStandardDeviationLayout();
    await loadStandardDeviationThreshold();
    await loadGraphLineWidth();
  }
}