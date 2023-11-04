import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/authentication/data/repositories/token_repository.dart';
import 'package:reading/debugging/presentation/controllers/debug_drawer_controller.dart';
import 'package:reading/debugging/presentation/widgets/debug_log.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:reading/shared/presentation/widgets/button_progress_indicator.dart';
import 'package:reading/shared/presentation/widgets/clipboard_copiable.dart';

class DebugDrawer extends HookConsumerWidget {
  const DebugDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverController = useTextEditingController(
      text: ref.read(restApiServerProvider).requireValue,
    );

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Rest API URL: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              TextField(
                controller: serverController,
                maxLines: 4,
                style: const TextStyle(fontSize: 14),
                textInputAction: TextInputAction.done,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonProgressIndicator(
                    isLoading:
                        ref.watch(debugDrawerControllerProvider).isLoading,
                    child: TextButton(
                      onPressed: () => ref
                          .read(debugDrawerControllerProvider.notifier)
                          .setRestApiUrl(serverController.text),
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'API token: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ClipboardCopiable(
                content: ref.watch(tokenProvider),
                child: TextFormField(
                  enabled: false,
                  initialValue: ref.watch(tokenProvider),
                  style: const TextStyle(fontSize: 14),
                ),
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
