import 'package:flutter/material.dart';

//Help separating stateful widget's layout and logic
abstract class WidgetView<T, U> extends StatelessWidget {
  final U state;

  T get widget => (state as State).widget as T;

  const WidgetView(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context);
}

//Example:
//class $NAME$ extends StatefulWidget {
//   @override
//   _$NAME$Controller createState() => _$NAME$Controller();
// }
// class _$NAME$Controller extends State<$NAME$> {
//   @override
//   Widget build(BuildContext context) => _$NAME$View(this);
// }
// class _$NAME$View extends WidgetView<$NAME$, _$NAME$Controller> {
//   _$NAME$View(_$NAME$Controller state) : super(state);
// @override
//   Widget build(BuildContext context) {
//     return Container($END$);
//   }
// }