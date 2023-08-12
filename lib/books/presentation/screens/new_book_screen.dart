import 'package:flutter/material.dart' hide Title;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/books/presentation/hooks/use_new_book_form_reducer.dart';
import 'package:reading/books/presentation/pages/new_book/new_book_page.dart';
import 'package:reading/profile/domain/value_objects/name.dart';
import 'package:reading/shared/presentation/hooks/use_page_notifier.dart';
import 'package:reading/shared/presentation/widgets/app_bar_leading.dart';
import 'package:reading/shared/presentation/widgets/simple_text_field.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NewBookScreen extends HookWidget {
  const NewBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final page = usePageNotifier(pageController);
    final newBookForm = useNewBookFormReducer();

    return Scaffold(
      appBar: AppBar(
        leading: ValueListenableBuilder(
          valueListenable: page,
          builder: (context, value, child) => AppBarLeading(
            onTap: value != 0 //
                ? () => _onTapBack(context, pageController)
                : null,
          ),
        ),
        title: const Text('Cadastrar Novo Livro'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
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
              controller: pageController,
              children: [
                NewBookPage(
                  builder: (context) => SimpleTextField(
                    autofocus: true,
                    fontSize: 36,
                    hintText: 'Título',
                    onChanged: (value) => newBookForm.dispatch(Title(value)),
                  ),
                  prompt: 'Qual o título do livro?',
                  onTapNext: newBookForm.state.title.value.isNotEmpty
                      ? () => _onTapNext(context, pageController)
                      : null,
                ),
                NewBookPage(
                  builder: (context) => SimpleTextField(
                    autofocus: true,
                    fontSize: 36,
                    hintText: 'Autor',
                    onChanged: (value) => newBookForm.dispatch(Name(value)),
                  ),
                  prompt: 'Qual o autor?',
                  onTapNext: newBookForm.state.author.value.isNotEmpty
                      ? () => _onTapNext(context, pageController)
                      : null,
                ),
                NewBookPage(
                  builder: (context) => const SizedBox(),
                  prompt: 'Inserir capa',
                  onTapNext: () => _onTapNext(context, pageController),
                  onTapSkip: () => _onTapNext(context, pageController),
                ),
                NewBookPage(
                  builder: (context) => SimpleTextField(
                    autofocus: true,
                    fontSize: 36,
                    hintText: '00',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                        newBookForm.dispatch(Pages.fromString(value)),
                  ),
                  prompt: 'Número de páginas',
                  onTapNext: switch (Pages.validate(
                    '${newBookForm.state.pages.value}',
                  )) {
                    null => () => _onTapNext(context, pageController),
                    _ => null,
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onTapBack(BuildContext context, PageController pageController) =>
      pageController.previousPage(
        duration: Theme.of(context).animationExtension!.duration,
        curve: Theme.of(context).animationExtension!.curve,
      );

  void _onTapNext(BuildContext context, PageController pageController) =>
      pageController.nextPage(
        duration: Theme.of(context).animationExtension!.duration,
        curve: Theme.of(context).animationExtension!.curve,
      );
}
