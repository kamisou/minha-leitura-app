import 'package:flutter/material.dart';
import 'package:reading/debugging/presentation/widgets/debug_drawer.dart';
import 'package:reading/shared/infrastructure/debugger.dart';

class DebugScaffold extends StatelessWidget {
  const DebugScaffold({
    super.key,
    this.appBar,
    this.backgroundColor,
    this.body,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
  });

  final PreferredSizeWidget? appBar;

  final Color? backgroundColor;

  final Widget? body;

  final Widget? bottomSheet;

  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Debugger.isDebugMode
        ? Scaffold(
            appBar: appBar,
            backgroundColor: backgroundColor,
            body: body,
            bottomSheet: bottomSheet,
            endDrawer: const DebugDrawer(),
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          )
        : Scaffold(
            appBar: appBar,
            backgroundColor: backgroundColor,
            body: body,
            bottomSheet: bottomSheet,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          );
  }
}
