import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/debugging/presentation/controllers/debug_drawer_controller.dart';
import 'package:reading/debugging/presentation/widgets/debug_drawer.dart';

Widget Function(BuildContext context, Widget? child) useDebugEndDrawerBuilder(
  WidgetRef ref,
) {
  return useCallback(
    (context, child) => Scaffold(
      body: child,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton.small(
          onPressed: Scaffold.of(context).openEndDrawer,
          child: const Icon(Icons.developer_mode),
        ),
      ),
      endDrawer: ref.read(debugDrawerStateProvider).isDebugMode
          ? const DebugDrawer()
          : null,
      endDrawerEnableOpenDragGesture: false,
    ),
  );
}
