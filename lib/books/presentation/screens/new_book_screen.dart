import 'package:flutter/material.dart' hide Title;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/books/presentation/pages/new_book/new_book_text_page.dart';
import 'package:reading/shared/presentation/widgets/app_bar_leading.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NewBookScreen extends HookWidget {
  const NewBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();

    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeading(),
        title: const Text('Cadastrar Novo Livro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SmoothPageIndicator(
                controller: pageController,
                count: 4,
                effect: WormEffect(
                  activeDotColor: Theme.of(context).colorScheme.primary,
                  dotColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  dotWidth: 8,
                  dotHeight: 8,
                ),
              ),
            ),
            Expanded(
              child: PageView(
                children: [
                  NewBookTextPage(
                    prompt: 'Qual o título do livro?',
                    hint: 'Título',
                    onChanged: (value) {},
                    validator: (value) => switch (Title.validate(value)) {
                      TitleError.empty => 'Informe o título do livro',
                      _ => null,
                    },
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () => pageController.nextPage(
                duration: Theme.of(context).animationExtension!.duration,
                curve: Theme.of(context).animationExtension!.curve,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Próximo'),
                  Icon(FeatherIcons.arrowRight),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
