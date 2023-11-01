import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/dtos/new_rating_dto.dart';
import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/rating.dart';
import 'package:reading/books/presentation/controllers/new_rating_controller.dart';
import 'package:reading/books/presentation/hooks/use_book_rating_form_reducer.dart';
import 'package:reading/books/presentation/widgets/star_rating_widget.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:reading/shared/presentation/hooks/use_controller_listener.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class NewRatingDialog extends HookConsumerWidget {
  const NewRatingDialog({
    super.key,
    required this.bookId,
    this.initialState,
  });

  final int bookId;

  final NewRatingDTO? initialState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookRatingForm = useBookRatingFormReducer(initialState: initialState);

    useControllerListener(
      ref,
      controller: newRatingControllerProvider,
      onError: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        OnlineOnlyOperationException() => 'Você precisa conectar-se à internet',
        _ => null,
      },
      onSuccess: context.pop,
    );

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'avaliação',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorExtension?.gray[800],
                ),
          ),
          const SizedBox(height: 20),
          StarRatingWidget(
            onChanged: (value) => bookRatingForm.dispatch(Rating(value)),
            enabled: true,
            value: bookRatingForm.state.rating.value,
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(hintText: 'comentário...'),
            initialValue: bookRatingForm.state.comment.value,
            maxLines: 4,
            onChanged: (value) => bookRatingForm.dispatch(Description(value)),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: context.pop,
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: () => ref
                      .read(newRatingControllerProvider.notifier)
                      .addRating(bookId, bookRatingForm.state),
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
