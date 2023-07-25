import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/intro/data/repositories/intro_repository.dart';
import 'package:reading/intro/presentation/hooks/use_intro_screen_theme_override.dart';
import 'package:reading/intro/presentation/pages/intro_page.dart';
import 'package:reading/shared/presentation/widgets/gradient_intro_background.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends HookConsumerWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeOverride = useIntroScreenThemeOverride();
    final pageController = usePageController();

    return Scaffold(
      body: Theme(
        data: themeOverride,
        child: Builder(
          builder: (context) => Stack(
            children: [
              const Positioned.fill(
                child: GradientIntroBackground(),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Center(
                        child: SmoothPageIndicator(
                          controller: pageController,
                          count: 4,
                          effect: WormEffect(
                            activeDotColor:
                                Theme.of(context).colorScheme.onPrimary,
                            dotColor: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.6),
                            dotWidth: 8,
                            dotHeight: 8,
                          ),
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          controller: pageController,
                          children: const [
                            IntroPage(
                              icon: FeatherIcons.clock,
                              title: 'Minha leitura',
                              body: 'Queremos te ajudar na criação do\n'
                                  'hábito da leitura, organizando e\n'
                                  'definindo metas para suas leituras',
                            ),
                            IntroPage(
                              icon: FeatherIcons.book,
                              title: 'Simples assim',
                              body: 'Pegue seus livros, insira os dados,\n'
                                  'defina suas metas e acompanhe suas\n'
                                  'leituras.',
                            ),
                            IntroPage(
                              icon: FeatherIcons.trendingUp,
                              title: 'Prático assim',
                              body: 'Acompanhe seu desempenho e\n'
                                  'registre suas anotações. Ah, sempre\n'
                                  'que precisar vamos estar aqui para\n'
                                  'não deixar você esquecer suas\n'
                                  'leituras!',
                            ),
                            IntroPage(
                              icon: FeatherIcons.thumbsUp,
                              title: 'Rápido assim',
                              body: 'Faça seu cadastro em menos de 2\n'
                                  'minutos, pegue seu livro da estante,\n'
                                  'vamos começar essa aventura, sem\n'
                                  'drama, rumo ao nosso final feliz...',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilledButton(
                              onPressed: () => context.go('/signup'),
                              child: const Text('Criar Conta'),
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton(
                              onPressed: () => ref
                                  .read(introRepositoryProvider)
                                  .setIntroSeen()
                                  .then((value) => context.go('/login')),
                              child: const Text('Entrar'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
