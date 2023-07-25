import 'package:flutter/material.dart';
import 'package:reading/shared/util/theme_data_extension.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';
import 'package:reading/shared/util/color_extension.dart';
import 'package:reading/statistics/presentation/widgets/meter.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const UserAppBar(),
        ),
        Text(
          'Lendo agora',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'Acompanhe sua evolução de leitura',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorExtension?.gray[600],
              ),
        ),
        const SizedBox(height: 24),
        Meter(
          curve: Theme.of(context).animationExtension!.curve,
          duration: Theme.of(context).animationExtension!.duration,
          value: 8.3,
          max: 10,
          radius: 74,
          backgroundColor: Theme.of(context).colorExtension?.gray[300],
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withLightness(0.9),
              Theme.of(context).colorScheme.primary,
            ],
          ),
          label: 'Leiturômetro',
          labelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorExtension?.gray[700],
                fontWeight: FontWeight.w700,
              ),
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
