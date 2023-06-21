import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class ObfuscatedTextFormField extends StatefulWidget {
  const ObfuscatedTextFormField({
    super.key,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.validator,
    this.decoration = const InputDecoration(),
  });

  final InputDecoration decoration;

  final void Function(String value)? onChanged;

  final void Function(String value)? onFieldSubmitted;

  final TextInputAction? textInputAction;

  final String? Function(String? value)? validator;

  @override
  State<ObfuscatedTextFormField> createState() =>
      _ObfuscatedTextFormFieldState();
}

class _ObfuscatedTextFormFieldState extends State<ObfuscatedTextFormField> {
  bool _obfuscated = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: widget.decoration.copyWith(
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _obfuscated = !_obfuscated),
          child: Icon(
            _obfuscated ? UniconsLine.eye_slash : UniconsLine.eye,
          ),
        ),
      ),
      obscureText: _obfuscated,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
    );
  }
}
