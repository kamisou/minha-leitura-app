import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';

class ServerSettingsDrawer extends ConsumerStatefulWidget {
  const ServerSettingsDrawer({super.key});

  static ServerSettingsDrawer? buildIfDebugMode({
    bool overrideDebugMode = false,
  }) =>
      kDebugMode ? const ServerSettingsDrawer() : null;

  @override
  ConsumerState<ServerSettingsDrawer> createState() =>
      _ServerSettingsDrawerState();
}

class _ServerSettingsDrawerState extends ConsumerState<ServerSettingsDrawer> {
  late TextEditingController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = TextEditingController(
      text: ref.read(restApiServerProvider).requireValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dev config',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Rest API URL: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              TextField(
                controller: _controller,
                maxLines: 4,
                style: const TextStyle(fontSize: 14),
                onEditingComplete: () async {
                  final scaffold = Scaffold.of(context);
                  await ref
                      .read(restApiServerProvider.notifier)
                      .set(_controller.text);
                  scaffold.closeDrawer();
                },
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
