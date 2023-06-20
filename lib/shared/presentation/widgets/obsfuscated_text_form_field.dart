import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class ObfuscatedTextFormField extends StatefulWidget {
  const ObfuscatedTextFormField({
    super.key,
    this.decoration = const InputDecoration(),
  });

  final InputDecoration decoration;

  @override
  State<ObfuscatedTextFormField> createState() =>
      _ObfuscatedTextFormFieldState();
}

class _ObfuscatedTextFormFieldState extends State<ObfuscatedTextFormField> {
  bool _obfuscated = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obfuscated,
      decoration: widget.decoration.copyWith(
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _obfuscated = !_obfuscated),
          child: Icon(
            _obfuscated ? UniconsLine.eye_slash : UniconsLine.eye,
          ),
        ),
      ),
    );
  }
}
