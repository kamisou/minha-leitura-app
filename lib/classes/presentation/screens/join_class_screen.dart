import 'package:flutter/material.dart';

import 'package:reading/classes/presentation/widgets/code_input.dart';

class JoinClassScreen extends StatelessWidget {
  const JoinClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Expanded(
              flex: 3,
              child: CodeInput(),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
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
}
