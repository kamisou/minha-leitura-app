import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class SimpleTextField extends StatelessWidget {
  const SimpleTextField({
    super.key,
    this.hintText,
    this.initialValue,
    this.inputFormatters,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.autofocus = false,
    this.fontSize = 52,
  });

  final String? hintText;

  final String? initialValue;

  final List<TextInputFormatter>? inputFormatters;

  final TextInputType? keyboardType;

  final void Function(String value)? onChanged;

  final String? Function(String? value)? validator;

  final bool autofocus;

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: false,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorExtension?.gray[250],
              fontSize: fontSize,
            ),
      ),
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      maxLines: null,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorExtension?.gray[600],
            fontSize: fontSize,
          ),
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.done,
      validator: validator,
    );
  }
}
