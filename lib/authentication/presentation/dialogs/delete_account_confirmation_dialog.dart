import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/profile/presentation/controllers/profile_controller.dart';
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
                  onPressed: () => _onDelete(context, ref),
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      color: Theme.of(context).colorExtension?.gray[600],
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.pop(),
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

  void _onDelete(BuildContext context, WidgetRef ref) {
    context.go('/login');
    ref
        .read(profileControllerProvider.notifier) //
        .deleteProfile()
        .then(
      (value) {
        if (ref.read(profileControllerProvider).asError == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Sua conta foi removida. Esperamos te ver novamente!',
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
