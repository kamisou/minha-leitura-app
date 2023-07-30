import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/shared/presentation/widgets/filled_icon_button.dart';

class ViewNoteDialog extends StatelessWidget {
  const ViewNoteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
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
      ],
    );
  }
}
