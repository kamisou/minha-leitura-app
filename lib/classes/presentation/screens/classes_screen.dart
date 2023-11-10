import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/classes/data/cached/classes.dart';
import 'package:reading/debugging/presentation/widgets/debug_scaffold.dart';
import 'package:reading/shared/presentation/hooks/use_asyncvalue_listener.dart';
import 'package:reading/shared/presentation/widgets/app_bar_leading.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:unicons/unicons.dart';

class ClassesScreen extends ConsumerWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAsyncValueListener(ref, myClassesProvider);

    return DebugScaffold(
      appBar: const UserAppBar(
        leading: AppBarLeading(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Text(
                'Suas Turmas',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
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
              child: RefreshIndicator(
                onRefresh: () => ref.refresh(myClassesProvider.future),
                child: ref.watch(myClassesProvider).maybeWhen(
                      data: (classes) => classes.isNotEmpty
                          ? ListView.separated(
                              itemCount: classes.length,
                              itemBuilder: (context, index) => Text(
                                '${classes[index].name} - '
                                '${classes[index].code}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorExtension
                                          ?.gray[800],
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              separatorBuilder: (context, index) =>
                                  const Divider(endIndent: 32),
                            )
                          : SingleChildScrollView(
                              child: Text(
                                'Você ainda não participa\n'
                                'de nenhuma turma!',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorExtension
                                          ?.gray[600],
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      orElse: () => const SizedBox(),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
