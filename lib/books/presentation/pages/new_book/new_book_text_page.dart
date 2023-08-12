import 'package:flutter/material.dart';
import 'package:reading/shared/presentation/widgets/simple_text_field.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class NewBookTextPage extends StatelessWidget {
  const NewBookTextPage({
    super.key,
    required this.prompt,
    required this.hint,
    required this.validator,
    required this.onChanged,
  });

  final String prompt;

  final String hint;

  final String? Function(String? value)? validator;

  final void Function(String value) onChanged;

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
            child: SimpleTextField(
              autofocus: true,
              hintText: hint,
              validator: validator,
              onChanged: onChanged,
              fontSize: 36,
            ),
          ),
        ),
      ],
    );
  }
}
