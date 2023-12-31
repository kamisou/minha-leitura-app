import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeInput extends StatefulWidget {
  const CodeInput({
    super.key,
    required this.length,
    this.onChanged,
  });

  final int length;

  final void Function(String value)? onChanged;

  @override
  State<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  late List<String> digits;

  @override
  void initState() {
    super.initState();
    digits = List.filled(widget.length, '');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < widget.length; i += 1)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                autofocus: true,
                cursorWidth: 0,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  counter: SizedBox(),
                  contentPadding: EdgeInsets.zero,
                  filled: false,
                ),
                keyboardType: TextInputType.visiblePassword,
                maxLength: 1,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters: [_ReplaceLowercaseTextInputFormatter()],
                onChanged: (value) {
                  digits[i] = value;

                  final focus = FocusManager.instance.primaryFocus;

                  if (value.isNotEmpty) {
                    if (i < digits.length - 1) {
                      focus?.nextFocus();
                    } else {
                      focus?.unfocus();
                    }
                  } else {
                    if (i != 0) {
                      focus?.previousFocus();
                    }
                  }

                  widget.onChanged?.call(digits.join());
                },
                showCursor: false,
                style: Theme.of(context).textTheme.titleLarge,
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
