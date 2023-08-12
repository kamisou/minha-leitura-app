import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class AppBarLeading extends StatelessWidget {
  const AppBarLeading({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.pop,
      child: Center(
        child: Container(
          decoration: ShapeDecoration(
            color: Theme.of(context).colorExtension?.gray[150],
            shape: const CircleBorder(),
          ),
          width: 40,
          height: 40,
          child: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorExtension?.gray[600],
          ),
        ),
      ),
    );
  }
}
