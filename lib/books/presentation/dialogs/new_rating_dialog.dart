import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/books/data/dtos/new_rating_dto.dart';
import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/rating.dart';
import 'package:reading/books/presentation/hooks/use_book_rating_form_reducer.dart';
import 'package:reading/books/presentation/widgets/star_rating_widget.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class NewRatingDialog extends HookWidget {
  const NewRatingDialog({
    super.key,
    this.rating,
  });

  final NewRatingDTO? rating;

  @override
  Widget build(BuildContext context) {
    final bookRatingForm = useBookRatingFormReducer(initialState: rating);

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
                  onPressed: () => context.pop(bookRatingForm.state),
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
