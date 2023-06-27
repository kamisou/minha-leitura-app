import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/authentication/data/repositories/auth_repository.dart';
import 'package:reading/classes/data/repositories/class_repository.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';
import 'package:unicons/unicons.dart';

class ClassesScreen extends ConsumerWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: UserAppBar(
          user: ref.watch(authRepositoryProvider).requireValue!,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Suas Turmas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go('/classes/join'),
              icon: const Icon(UniconsLine.signin),
              label: const Text('Ingressar'),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ref.watch(myClassesProvider).maybeWhen(
                    data: (classes) => ListView.separated(
                      itemCount: classes.length,
                      itemBuilder: (context, index) => Text(
                        '${classes[index].name} - ${classes[index].code}',
                      ),
                      separatorBuilder: (context, index) =>
                          const Divider(endIndent: 32),
                    ),
                    orElse: () => const SizedBox(),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
