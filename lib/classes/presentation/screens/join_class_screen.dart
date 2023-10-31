import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/classes/presentation/controllers/join_class_controller.dart';
import 'package:reading/classes/presentation/widgets/code_input.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:reading/shared/presentation/hooks/use_snackbar_error_listener.dart';
import 'package:reading/shared/presentation/widgets/app_bar_leading.dart';
import 'package:reading/shared/presentation/widgets/button_progress_indicator.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class JoinClassScreen extends HookConsumerWidget {
  const JoinClassScreen({super.key});

  static const _codeLength = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = useState('');

    useSnackbarListener(
      ref,
      provider: joinClassControllerProvider,
      onError: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        OnlineOnlyOperationException() =>
          'Você precisa estar online para entrar na turma',
        _ => 'Não foi possível entrar na turma',
      },
      onSuccess: () => context.go('/classes'),
    );

    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        title: Text(
          'Ingressar em turma',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Qual o código da turma?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorExtension?.gray[800],
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: CodeInput(
                length: _codeLength,
                onChanged: (value) => code.value = value,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ButtonProgressIndicator(
                    isLoading: ref.watch(joinClassControllerProvider).isLoading,
                    onPressed: code.value.length == _codeLength
                        ? () => _join(context, ref, code.value)
                        : null,
                    child: const Text('Confirmar'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _join(BuildContext context, WidgetRef ref, String code) {
    ref.read(joinClassControllerProvider.notifier).joinClass(code);
  }
}
