import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:reading/shared/util/color_extension.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class NewBookWidget extends StatelessWidget {
  const NewBookWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 356,
      decoration: ShapeDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(0, 4),
            color: Color(0x33000000),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
              color: Theme.of(context).colorScheme.primary.withLightness(.95),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            width: 64,
            height: 64,
            child: Icon(
              FeatherIcons.plus,
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Novo Livro',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Adicione mais\nlivros a sua coleção',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorExtension?.gray[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
