import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/classes/presentation/controllers/join_class_controller.dart';
import 'package:reading/classes/presentation/widgets/code_input.dart';
import 'package:reading/shared/presentation/widgets/button_progress_indicator.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class JoinClassContent extends HookConsumerWidget {
  const JoinClassContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const codeLength = 6;
    final code = useState('');

    return Column(
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
            length: codeLength,
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
                child: FilledButton(
                  onPressed: code.value.length == codeLength
                      ? () => ref
                          .read(joinClassControllerProvider.notifier)
                          .joinClass(code.value)
                      : null,
                  child: const Text('Confirmar'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
