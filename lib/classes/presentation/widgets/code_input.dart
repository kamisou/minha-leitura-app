import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeInput extends StatelessWidget {
  const CodeInput({
    super.key,
    this.length = 6,
  });

  final int length;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < length; i += 1)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                autofocus: i == 0,
                cursorWidth: 0,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  counter: SizedBox(),
                  contentPadding: EdgeInsets.zero,
                  filled: false,
                ),
                keyboardType: TextInputType.visiblePassword,
                inputFormatters: [_ReplaceLowercaseTextInputFormatter()],
                maxLength: 1,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                onChanged: (value) {
                  final focus = FocusManager.instance.primaryFocus;
                  if (value.isEmpty) {
                    focus?.previousFocus();
                  } else {
                    focus?.nextFocus();
                  }
                },
                showCursor: false,
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class _ReplaceLowercaseTextInputFormatter implements TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.replaceAllMapped(
        RegExp('[a-z]'),
        (match) => match[0]!.toUpperCase(),
      ),
    );
  }
}
