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
  });

  final PreferredSizeWidget? appBar;

  final Color? backgroundColor;

  final Widget? body;

  final Widget? bottomSheet;

  @override
  Widget build(BuildContext context) {
    return Debugger.isDebugMode
        ? Scaffold(
            appBar: appBar,
            backgroundColor: backgroundColor,
            body: body,
            bottomSheet: bottomSheet,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndTop,
            floatingActionButton: Builder(
              builder: (context) => FloatingActionButton.small(
                onPressed: Scaffold.of(context).openEndDrawer,
                child: const Icon(Icons.developer_mode),
              ),
            ),
            endDrawer: Debugger.isDebugMode ? const DebugDrawer() : null,
            endDrawerEnableOpenDragGesture: false,
          )
        : Scaffold(body: body);
  }
}
