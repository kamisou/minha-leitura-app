import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class GreetingContent extends StatelessWidget {
  const GreetingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: 'Seja bem-vindo ao\n',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
            children: const [
              TextSpan(
                text: 'Minha Leitura',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 36),
        const SvgPicture(
          AssetBytesLoader('assets/vectors/compiled/home-1.svg.vec'),
        ),
        const SizedBox(height: 24),
        Text(
          'Que tal iniciar uma\n'
          'leitura agora mesmo?',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Cadastrar seu primeiro livro para gerenciar o\n'
          'progresso de leitura, fazer anotações e muito mais!',
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        Center(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Cadastre um Livro'),
          ),
        ),
      ],
    );
  }
}
