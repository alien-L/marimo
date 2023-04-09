import 'package:flutter/cupertino.dart';
import 'environment/environment.dart';
import 'language.dart';

///
/// Created by ahhyun [ah2yun@gmail.com] on 2023. 03. 30
///

// 앱 다시 시작 위젯
class RestartWidget extends StatefulWidget {
  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context,Language language) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp(language);
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp(Language language) {
    setState(() {
      Environment().initConfig(language);
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}