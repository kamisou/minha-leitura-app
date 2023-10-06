import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/data/repositories/book_note_repository.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/presentation/controllers/new_note_controller.dart';
import 'package:reading/books/presentation/dialogs/new_note_dialog.dart';
import 'package:reading/shared/presentation/hooks/use_dd_mm_yy_h_m.dart';
import 'package:reading/shared/presentation/widgets/filled_icon_button.dart';
import 'package:reading/shared/util/color_extension.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:unicons/unicons.dart';

class ViewNoteDialog extends HookConsumerWidget {
  const ViewNoteDialog({
    super.key,
    required this.note,
  });

  final BookNote note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      child: Column(
        children: [
          Row(
            children: [
              FilledIconButton(
                onPressed: context.pop,
                icon: FeatherIcons.chevronLeft,
              ),
              const Spacer(),
              FilledIconButton(
                onPressed: () {
                  // TODO: implement share note
                  throw UnimplementedError();
                },
                icon: FeatherIcons.share2,
              ),
            ],
          ),
          const SizedBox(height: 28),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorExtension?.gray[800],
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note is! OfflineBookNote
                        ? useddMMyyHm(note.createdAt!)
                        : 'Não sincronizado',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorExtension?.gray[500],
                        ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        child: Text(
                          note.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color:
                                    Theme.of(context).colorExtension?.gray[600],
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: note.replies.isEmpty
                              ? () => ref
                                  .read(bookNoteRepositoryProvider)
                                  .removeNote(note)
                              : null,
                          icon: const Icon(UniconsLine.trash),
                          label: const Text('Remover'),
                          style: ButtonStyle(
                            backgroundColor:
                                const Color(0xFFF5F5F5).materialStateAll,
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .materialStateAll,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            final newNoteController =
                                ref.read(newNoteControllerProvider.notifier);
                            context.pop();
                            showModalBottomSheet<NewNoteDTO?>(
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              context: context,
                              isScrollControlled: true,
                              showDragHandle: true,
                              builder: (context) => NewNoteDialog(note: note),
                            ).then(
                              (value) => value != null
                                  ? newNoteController.updateNote(note, value)
                                  : null,
                            );
                          },
                          icon: const Icon(UniconsLine.edit),
                          label: const Text('Editar'),
                          style: ButtonStyle(
                            backgroundColor:
                                const Color(0xFFF5F5F5).materialStateAll,
                            foregroundColor: Theme.of(context)
                                .colorExtension
                                ?.information
                                .materialStateAll,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
