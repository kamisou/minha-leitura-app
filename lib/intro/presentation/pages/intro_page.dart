import 'package:flutter/material.dart';
import 'package:reading/intro/presentation/widgets/speech_bubble.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;

  final String title;

  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpeechBubble(
            icon: Icon(
              icon,
              size: 64,
            ),
          ),
          const SizedBox(height: 64),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          Text(
            body,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
