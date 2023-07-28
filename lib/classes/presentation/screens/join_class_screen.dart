import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/classes/presentation/controllers/join_class_controller.dart';
import 'package:reading/classes/presentation/widgets/code_input.dart';
import 'package:reading/shared/infrastructure/rest_api.dart';
import 'package:reading/shared/presentation/hooks/use_snackbar_error_listener.dart';
import 'package:reading/shared/presentation/widgets/button_progress_indicator.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class JoinClassScreen extends HookConsumerWidget {
  const JoinClassScreen({super.key});

  static const _codeLength = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = useState('');

    useSnackbarErrorListener(
      ref,
      provider: joinClassControllerProvider,
      messageBuilder: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        NoResponseRestException() =>
          'Você está sem acesso à internet. Tente novamente mais tarde.',
        _ => 'Ocorreu um erro inesperado.',
      },
    );

    return Scaffold(
      appBar: AppBar(
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
    ref
        .read(joinClassControllerProvider.notifier)
        .joinClass(code)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sucesso! Você ingressou na turma!'),
        ),
      );
      context.go('/classes');
    });
  }
}
