import 'package:flutter/material.dart' hide Title;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/books/presentation/hooks/use_new_book_form_reducer.dart';
import 'package:reading/books/presentation/pages/new_book/new_book_page.dart';
import 'package:reading/profile/domain/value_objects/name.dart';
import 'package:reading/shared/infrastructure/image_picker.dart';
import 'package:reading/shared/presentation/hooks/use_page_notifier.dart';
import 'package:reading/shared/presentation/widgets/app_bar_leading.dart';
import 'package:reading/shared/presentation/widgets/book_cover.dart';
import 'package:reading/shared/presentation/widgets/simple_text_field.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:unicons/unicons.dart';

class NewBookScreen extends HookConsumerWidget {
  const NewBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 72,
                      vertical: 96,
                    ),
                    child: newBookForm.state.file != null
                        ? BookCover.file(
                            file: newBookForm.state.file,
                          )
                        : GestureDetector(
                            onTap: () =>
                                ref.read(imagePickerProvider).pickImage().then(
                                      (value) => value == null
                                          ? null
                                          : newBookForm.dispatch(value),
                                    ),
                            child: AspectRatio(
                              aspectRatio: 0.7,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 12,
                                      color: Color(0x18000000),
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      UniconsLine.image_plus,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Adicionar Imagem',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                  prompt: 'Inserir capa',
                  onTapNext: newBookForm.state.file != null
                      ? () => _onTapNext(context, pageController)
                      : null,
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

  void _onTapBack(BuildContext context, PageController pageController) {
    FocusManager.instance.primaryFocus?.unfocus();
    pageController.previousPage(
      duration: Theme.of(context).animationExtension!.duration,
      curve: Theme.of(context).animationExtension!.curve,
    );
  }

  void _onTapNext(BuildContext context, PageController pageController) {
    FocusManager.instance.primaryFocus?.unfocus();
    pageController.nextPage(
      duration: Theme.of(context).animationExtension!.duration,
      curve: Theme.of(context).animationExtension!.curve,
    );
  }
}
