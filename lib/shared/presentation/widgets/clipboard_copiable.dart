import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipboardCopiable extends StatelessWidget {
  const ClipboardCopiable({
    super.key,
    required this.child,
    required this.content,
  });

  final Widget child;

  final String? content;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: content != null
          ? () => Clipboard.setData(ClipboardData(text: content!)).then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Copiado para a área de transferência'),
                    ),
                  ),
                ),
              )
          : null,
      child: child,
    );
  }
}
