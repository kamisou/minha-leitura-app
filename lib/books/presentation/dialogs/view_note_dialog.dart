import 'package:flutter/material.dart' hide Title;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reading/books/data/dtos/new_note_dto.dart';
import 'package:reading/books/domain/models/book_note.dart';
import 'package:reading/books/domain/value_objects/description.dart';
import 'package:reading/books/domain/value_objects/title.dart';
import 'package:reading/books/presentation/controllers/new_note_controller.dart';
import 'package:reading/books/presentation/dialogs/note_edit_dialog.dart';
import 'package:reading/profile/data/cached/profile.dart';
import 'package:reading/shared/exceptions/repository_exception.dart';
import 'package:reading/shared/exceptions/rest_exception.dart';
import 'package:reading/shared/presentation/hooks/use_controller_listener.dart';
import 'package:reading/shared/presentation/widgets/button_progress_indicator.dart';
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
    useControllerListener(
      ref,
      controller: newNoteControllerProvider,
      onError: (error) => switch (error) {
        BadResponseRestException(message: final message) => message,
        OnlineOnlyOperationException() => 'Você precisa conectar-se à internet',
        _ => null,
      },
      onSuccess: context.pop,
    );

    return Padding(
      padding: const EdgeInsets.only(
        top: 40,
        right: 16,
        bottom: 16,
        left: 16,
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
                        ? DateFormat.yMd().add_jm().format(note.createdAt!)
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
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: (note.author.id ==
                            ref.watch(profileProvider).requireValue!.id)
                        ? Row(
                            children: [
                              Expanded(
                                child: ButtonProgressIndicator(
                                  isLoading: ref
                                      .watch(newNoteControllerProvider)
                                      .isLoading,
                                  child: ButtonProgressIndicator(
                                    isLoading: ref
                                        .watch(newNoteControllerProvider)
                                        .isLoading,
                                    child: FilledButton.icon(
                                      onPressed: note.replies.isEmpty
                                          ? () => ref
                                              .read(
                                                newNoteControllerProvider
                                                    .notifier,
                                              )
                                              .removeNote(note)
                                          : null,
                                      icon: const Icon(UniconsLine.trash),
                                      label: const Text('Remover'),
                                      style: ButtonStyle(
                                        backgroundColor: const Color(0xFFF5F5F5)
                                            .materialStateAll,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .materialStateAll,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ButtonProgressIndicator(
                                  isLoading: ref
                                      .watch(newNoteControllerProvider)
                                      .isLoading,
                                  child: FilledButton.icon(
                                    onPressed: () => showModalBottomSheet<void>(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      context: context,
                                      isScrollControlled: true,
                                      showDragHandle: true,
                                      builder: (context) => NoteEditDialog(
                                        title: 'Atualizar nota',
                                        callback: (controller) => (data) =>
                                            controller.updateNote(note, data),
                                        initialState: NewNoteDTO(
                                          title: Title(note.title),
                                          description: Description(
                                            note.description,
                                          ),
                                        ),
                                      ),
                                    ),
                                    icon: const Icon(UniconsLine.edit),
                                    label: const Text('Editar'),
                                    style: ButtonStyle(
                                      backgroundColor: const Color(0xFFF5F5F5)
                                          .materialStateAll,
                                      foregroundColor: Theme.of(context)
                                          .colorExtension
                                          ?.information
                                          .materialStateAll,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : FilledButton.icon(
                            onPressed: () => showModalBottomSheet<void>(
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              context: context,
                              isScrollControlled: true,
                              showDragHandle: true,
                              builder: (context) => NoteEditDialog(
                                title: 'Responder nota',
                                callback: (controller) => (data) => controller
                                    .replyNote(note.bookId, note.id!, data),
                              ),
                            ),
                            icon: const Icon(UniconsLine.trash),
                            label: const Text('Responder'),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
