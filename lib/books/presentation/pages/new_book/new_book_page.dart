import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:reading/shared/presentation/widgets/button_progress_indicator.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class NewBookPage extends StatelessWidget {
  const NewBookPage({
    super.key,
    required this.builder,
    required this.prompt,
    this.onTapNext,
    this.onTapSkip,
    this.isLoading = false,
  });

  final WidgetBuilder builder;

  final String prompt;

  final void Function()? onTapNext;

  final void Function()? onTapSkip;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          prompt,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorExtension?.gray[600],
                fontWeight: FontWeight.w400,
              ),
        ),
        Expanded(
          child: Center(
            child: builder(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (onTapSkip != null) ...[
                OutlinedButton(
                  onPressed: onTapSkip,
                  child: const Text('Pular'),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: ButtonProgressIndicator(
                  isLoading: isLoading,
                  child: FilledButton(
                    onPressed: onTapNext,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Próximo'),
                        SizedBox(width: 10),
                        Icon(FeatherIcons.arrowRight),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
