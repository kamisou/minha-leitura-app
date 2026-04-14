import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/profile/presentation/controllers/delete_profile_controller.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class DeleteAccountConfirmationDialog extends ConsumerWidget {
  const DeleteAccountConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 24,
          right: 24,
          bottom: 8,
          left: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Deletar conta!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tem certeza que deseja deletar sua conta e todos os seus dados '
              'associados?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorExtension?.gray[600],
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    ref
                        .read(deleteProfileControllerProvider.notifier)
                        .deleteProfile();

                    context.pop();
                  },
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      color: Theme.of(context).colorExtension?.gray[600],
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: context.pop,
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
