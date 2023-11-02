import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:reading/shared/presentation/widgets/debug_log.dart';

class DebugSettingsDrawer extends HookConsumerWidget {
  const DebugSettingsDrawer({super.key});

  static DebugSettingsDrawer? buildIfDebugMode({
    bool overrideDebugMode = false,
  }) =>
      kDebugMode || overrideDebugMode ? const DebugSettingsDrawer() : null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(
      text: ref.read(restApiServerProvider).valueOrNull,
    );

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
                controller: controller,
                maxLines: 4,
                style: const TextStyle(fontSize: 14),
                onEditingComplete: () async {
                  final scaffold = Scaffold.of(context);
                  await ref
                      .read(restApiServerProvider.notifier)
                      .set(controller.text);
                  scaffold.closeDrawer();
                },
                textInputAction: TextInputAction.done,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Log de erros',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const Expanded(
                child: DebugLog(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
