import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/classes/presentation/controllers/join_class_controller.dart';
import 'package:reading/classes/presentation/screens/content/join_class_content.dart';
import 'package:reading/classes/presentation/screens/content/offline_join_class_content.dart';
import 'package:reading/debugging/presentation/widgets/debug_scaffold.dart';
import 'package:reading/shared/data/cached/connection_status.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:reading/shared/presentation/hooks/use_controller_listener.dart';
import 'package:reading/shared/presentation/widgets/app_bar_leading.dart';

class JoinClassScreen extends HookConsumerWidget {
  const JoinClassScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useControllerListener(
      ref,
      controller: joinClassControllerProvider,
      onError: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        _ => null,
      },
      onSuccess: () => context.go('/classes'),
    );

    return DebugScaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        title: Text(
          'Ingressar em turma',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ref.watch(isConnectedProvider)
            ? const JoinClassContent()
            : const OfflineJoinClassContent(),
      ),
    );
  }
}
