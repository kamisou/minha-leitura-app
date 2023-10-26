import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reading/books/data/dtos/new_book_dto.dart';
import 'package:reading/books/domain/models/book.dart';
import 'package:reading/books/domain/models/book_details.dart';
import 'package:reading/books/domain/value_objects/date.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/books/presentation/controllers/new_book_controller.dart';
import 'package:reading/books/presentation/hooks/use_new_book_form_reducer.dart';
import 'package:reading/books/presentation/pages/new_book/book_search_result_page.dart';
import 'package:reading/books/presentation/pages/new_book/new_book_page.dart';
import 'package:reading/books/presentation/widgets/selection_button.dart';
import 'package:reading/profile/domain/value_objects/name.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:reading/shared/infrastructure/image_picker.dart';
import 'package:reading/shared/presentation/hooks/use_page_notifier.dart';
import 'package:reading/shared/presentation/hooks/use_snackbar_error_listener.dart';
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
    final manualRegister = useState<bool?>(null);
    final searchTerm = useState('');
    final selectedBook = useRef<Book?>(null);

    useSnackbarErrorListener(
      ref,
      provider: newBookControllerProvider,
      messageBuilder: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        OnlineOnlyOperationException() =>
          'Você precisa estar online para registrar um novo livro!',
        _ => null,
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: AppBarLeading(
          onTap: () {
            page.value == 0 //
                ? context.pop()
                : _onTapBack(context, pageController);
          },
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
              count: switch (newBookForm.state.status) {
                BookStatus.reading || BookStatus.finished => 7,
                _ => 5,
              },
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
              physics: const NeverScrollableScrollPhysics(),
              children: [
                NewBookPage(
                  key: const ValueKey(0),
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SelectionButton(
                          onPressed: () => manualRegister.value = true,
                          icon: FeatherIcons.fileText,
                          text: 'Cadastrar manualmente',
                          selected: (manualRegister.value ?? false) == true,
                        ),
                        const SizedBox(height: 16),
                        SelectionButton(
                          onPressed: () => manualRegister.value = false,
                          icon: FeatherIcons.search,
                          text: 'Pesquisar na nossa base',
                          selected: manualRegister.value == false,
                        ),
                      ],
                    ),
                  ),
                  prompt: 'Como deseja cadastrar seu livro?',
                  onTapNext: manualRegister.value != null
                      ? () => _onTapNext(context, pageController)
                      : null,
                ),
                ...switch (manualRegister.value) {
                  false => [
                      Column(
                        key: const ValueKey(1),
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: SimpleTextField(
                              autofocus: true,
                              fontSize: 24,
                              hintText: 'Qual o título do livro?',
                              initialValue: searchTerm.value,
                              onChanged: (value) => searchTerm.value = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: FilledButton(
                              onPressed: searchTerm.value.isNotEmpty
                                  ? () => _onTapNext(context, pageController)
                                  : null,
                              child: const Text('Buscar'),
                            ),
                          ),
                        ],
                      ),
                      BookSearchResultPage(
                        searchTerm: searchTerm.value,
                        onTapBook: (book) {
                          selectedBook.value = book;
                          _onTapNext(context, pageController);
                        },
                      ),
                    ],
                  true => [
                      NewBookPage(
                        key: const ValueKey(1),
                        builder: (context) => SimpleTextField(
                          autofocus: true,
                          fontSize: 36,
                          hintText: 'Título',
                          onChanged: (value) =>
                              newBookForm.dispatch(Title(value)),
                        ),
                        prompt: 'Qual o título do livro?',
                        onTapNext: newBookForm.state.title.value.isNotEmpty
                            ? () => _onTapNext(context, pageController)
                            : null,
                      ),
                      NewBookPage(
                        key: const ValueKey(2),
                        builder: (context) => SimpleTextField(
                          autofocus: true,
                          fontSize: 36,
                          hintText: 'Autor',
                          onChanged: (value) =>
                              newBookForm.dispatch(Name(value)),
                        ),
                        prompt: 'Qual o autor?',
                        onTapNext: newBookForm.state.author.value.isNotEmpty
                            ? () => _onTapNext(context, pageController)
                            : null,
                      ),
                      NewBookPage(
                        key: const ValueKey(3),
                        builder: (context) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 72,
                            vertical: 96,
                          ),
                          child: GestureDetector(
                            onTap: () => ref
                                .read(imagePickerProvider)
                                .pickImage(
                                  maxWidth: 300,
                                  maxHeight: 428,
                                  quality: 90,
                                )
                                .then(
                                  (value) => value == null
                                      ? null
                                      : newBookForm.dispatch(value),
                                ),
                            child: newBookForm.state.cover != null
                                ? BookCover.file(
                                    file: newBookForm.state.cover,
                                  )
                                : AspectRatio(
                                    aspectRatio: 0.7,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 12,
                                            color: Color(0x18000000),
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            UniconsLine.image_plus,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
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
                        onTapNext: newBookForm.state.cover != null
                            ? () => _onTapNext(context, pageController)
                            : null,
                        onTapSkip: () => _onTapNext(context, pageController),
                      ),
                      NewBookPage(
                        key: const ValueKey(4),
                        builder: (context) => SimpleTextField(
                          autofocus: true,
                          fontSize: 36,
                          hintText: '00',
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          onChanged: (value) => newBookForm
                              .dispatch({'pages': Pages.fromString(value)}),
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
                  null => <Widget>[],
                },
                NewBookPage(
                  key: const ValueKey(5),
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SelectionButton(
                          onPressed: () =>
                              newBookForm.dispatch(BookStatus.pending),
                          text: 'vou iniciar agora',
                          selected:
                              newBookForm.state.status == BookStatus.pending,
                        ),
                        const SizedBox(height: 16),
                        SelectionButton(
                          onPressed: () =>
                              newBookForm.dispatch(BookStatus.reading),
                          text: 'estou lendo',
                          selected:
                              newBookForm.state.status == BookStatus.reading,
                        ),
                        const SizedBox(height: 16),
                        SelectionButton(
                          onPressed: () =>
                              newBookForm.dispatch(BookStatus.finished),
                          text: 'já li esse livro',
                          selected:
                              newBookForm.state.status == BookStatus.finished,
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Checkbox(
                              value: newBookForm.state.haveTheBook == 1,
                              onChanged: (value) =>
                                  newBookForm.dispatch(value! ? 1 : 0),
                            ),
                            Text(
                              'Eu tenho esse livro',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorExtension
                                        ?.gray[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  prompt: 'Leitura',
                  onTapNext: newBookForm.state.status != null
                      ? () => switch (newBookForm.state.status) {
                            BookStatus.pending => _finish(
                                context,
                                ref,
                                selectedBook.value,
                                newBookForm.state,
                              ),
                            BookStatus.reading ||
                            BookStatus.finished =>
                              _onTapNext(context, pageController),
                            _ => null,
                          }
                      : null,
                ),
                ...switch (newBookForm.state.status) {
                  BookStatus.reading => [
                      NewBookPage(
                        key: const ValueKey(6),
                        builder: (context) => SimpleTextField(
                          autofocus: true,
                          fontSize: 36,
                          hintText: 'dd/mm/aa',
                          inputFormatters: [
                            TextInputMask(mask: '99/99/99'),
                          ],
                          keyboardType: TextInputType.datetime,
                          onChanged: (value) => newBookForm.dispatch(
                            {'started_at': Date.fromString(value)},
                          ),
                        ),
                        prompt: 'Quando começou a ler?',
                        onTapNext: switch (Date.validate(
                          newBookForm.state.startedAt.value != null
                              ? DateFormat('dd/MM/yy')
                                  .format(newBookForm.state.startedAt.value!)
                              : null,
                        )) {
                          null => () => _onTapNext(context, pageController),
                          _ => null,
                        },
                      ),
                      NewBookPage(
                        key: const ValueKey(7),
                        builder: (context) => SimpleTextField(
                          autofocus: true,
                          fontSize: 36,
                          hintText: '00',
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          onChanged: (value) => newBookForm.dispatch(
                            {'actual_page': Pages.fromString(value)},
                          ),
                        ),
                        prompt: 'Parou em qual página?',
                        onTapNext: switch (Pages.validate(
                          '${newBookForm.state.actualPage.value}',
                        )) {
                          null => () => _finish(
                                context,
                                ref,
                                selectedBook.value,
                                newBookForm.state,
                              ),
                          _ => null,
                        },
                      ),
                    ],
                  BookStatus.finished => [
                      NewBookPage(
                        key: const ValueKey(6),
                        builder: (context) => SimpleTextField(
                          autofocus: true,
                          fontSize: 36,
                          hintText: 'dd/mm/aa',
                          inputFormatters: [
                            TextInputMask(mask: '99/99/99'),
                          ],
                          keyboardType: TextInputType.datetime,
                          onChanged: (value) => newBookForm.dispatch(
                            {'started_at': Date.fromString(value)},
                          ),
                        ),
                        prompt: 'Quando você leu?',
                        onTapNext: switch (Date.validate(
                          newBookForm.state.startedAt.value != null
                              ? DateFormat('dd/MM/yy')
                                  .format(newBookForm.state.startedAt.value!)
                              : null,
                        )) {
                          null => () => _onTapNext(context, pageController),
                          _ => null,
                        },
                      ),
                      NewBookPage(
                        key: const ValueKey(7),
                        builder: (context) => SimpleTextField(
                          autofocus: true,
                          fontSize: 36,
                          hintText: 'dd/mm/aa',
                          inputFormatters: [
                            TextInputMask(mask: '99/99/99'),
                          ],
                          keyboardType: TextInputType.datetime,
                          onChanged: (value) => newBookForm.dispatch(
                            {'finished_at': Date.fromString(value)},
                          ),
                        ),
                        prompt: 'Quando terminou?',
                        onTapNext: switch (Date.validate(
                          newBookForm.state.finishedAt.value != null
                              ? DateFormat('dd/MM/yy')
                                  .format(newBookForm.state.finishedAt.value!)
                              : null,
                        )) {
                          null => () => _finish(
                                context,
                                ref,
                                selectedBook.value,
                                newBookForm.state,
                              ),
                          _ => null,
                        },
                      ),
                    ],
                  _ => [
                      const SizedBox(key: ValueKey(6)),
                    ],
                },
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _finish(
    BuildContext context,
    WidgetRef ref,
    Book? book,
    NewBookDTO data,
  ) {
    FocusManager.instance.primaryFocus?.unfocus();

    final controller = ref.read(newBookControllerProvider.notifier);

    final work = (book == null)
        ? controller.addBookAndReading(data)
        : controller.addReading(book, data);

    // ignore: cascade_invocations
    work.then(
      (value) => ref.read(newBookControllerProvider).asError == null
          ? context.pop()
          : null,
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
