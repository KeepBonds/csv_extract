import 'package:csv_extract/manager/manager.dart';
import 'package:csv_extract/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../../constants/ColorTemplateConst.dart';
import '../../object/ColorTemplate.dart';

const double kColorSize = 39.0;

class ColorSelectDialog extends StatelessWidget {
  const ColorSelectDialog({Key? key}) : super(key: key);

  onPressedTemplate(BuildContext context, ColorTemplate colorTemplate) {
    SettingsManager.getState().saveColorTemplate(colorTemplate);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(22.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ThemeButton(
              template: defaultTemplate,
              onPressed: () => onPressedTemplate(context, defaultTemplate),
            ),
            ThemeButton(
              template: blindColorTemplate,
              onPressed: () => onPressedTemplate(context, blindColorTemplate),
            ),
            ThemeButton(
              template: blindColorTemplate2,
              onPressed: () => onPressedTemplate(context, blindColorTemplate2),
            ),
            ThemeButton(
              template: whiteTemplate,
              onPressed: () => onPressedTemplate(context, whiteTemplate),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeButton extends StatelessWidget {
  final ColorTemplate template;
  final Function() onPressed;

  const ThemeButton({
    Key? key,
    required this.template,
    required this.onPressed,
  }) : super(key: key);


  Widget colorWidget(Color color) {
    return Container(
        decoration: BoxDecoration(
            color: color,
            border: Border.all(color: color == Colors.white ? Colors.black26 : color, width: 0.5)
        ),
        child: const SizedBox(
          height: kColorSize,
          width: kColorSize,
        )
    );
  }

  Widget rowText() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Expanded(child: Text("")),
          textWidget("Pass"),
          textWidget("Margin Pass"),
          textWidget("Margin Fail"),
          textWidget("Fail"),
          textWidget("No Data"),
          textWidget("No Spec"),
        ],
      ),
    );
  }

  Widget textWidget(String text) {
    return Container(
      height: kColorSize + 1,
      width: kColorSize + 1,
      child: Center(
        child: Text(text, style: const TextStyle(color: Colors.black, fontSize: 11), textAlign: TextAlign.center, ),
      ),
    );
  }

  Widget rowColor(ColorTemplate colorTemplate) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Text(colorTemplate.name, style: TextStyle(color: kColor),)),
          colorWidget(colorTemplate.pass),
          colorWidget(colorTemplate.marginPass),
          colorWidget(colorTemplate.marginFail),
          colorWidget(colorTemplate.fail),
          colorWidget(colorTemplate.noData),
          colorWidget(colorTemplate.noSpec),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(4.0)
          ),
          onPressed: onPressed,
          child: Column(
            children: [
              rowText(),
              rowColor(template)
            ],
          )
      ),
    );
  }
}
