import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class OfflineJoinClassContent extends StatelessWidget {
  const OfflineJoinClassContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Você está sem acesso à internet.\n'
          'Tente novamente mais tarde.',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Theme.of(context).colorExtension?.gray[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Icon(
          FeatherIcons.wifiOff,
          color: Theme.of(context).colorScheme.primary,
          size: 80,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
