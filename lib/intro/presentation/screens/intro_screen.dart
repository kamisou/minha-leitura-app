import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/authentication/presentation/hooks/use_intro_screen_theme_override.dart';
import 'package:reading/common/presentation/widgets/gradient_intro_background.dart';
import 'package:reading/intro/presentation/pages/intro_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:unicons/unicons.dart';

class IntroScreen extends HookWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeOverride = useIntroScreenThemeOverride(Theme.of(context));
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
                              icon: UniconsThinline.clock,
                              title: 'Minha leitura',
                              body: 'Queremos te ajudar na criação do\n'
                                  'hábito da leitura, organizando e\n'
                                  'definindo metas para suas leituras',
                            ),
                            IntroPage(
                              // TODO(kamisou): fix icon
                              icon: UniconsThinline.bookmark,
                              title: 'Simples assim',
                              body: 'Pegue seus livros, insira os dados,\n'
                                  'defina suas metas e acompanhe suas\n'
                                  'leituras.',
                            ),
                            IntroPage(
                              // TODO(kamisou): fix icon
                              icon: UniconsThinline.arrow_up_right,
                              title: 'Prático assim',
                              body: 'Acompanhe seu desempenho e\n'
                                  'registre suas anotações. Ah, sempre\n'
                                  'que precisar vamos estar aqui para\n'
                                  'não deixar você esquecer suas\n'
                                  'leituras!',
                            ),
                            IntroPage(
                              // TODO(kamisou): fix icon
                              icon: UniconsThinline.process,
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
                              // TODO(kamisou): criar conta
                              onPressed: () {},
                              child: const Text('Criar Conta'),
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton(
                              // TODO(kamisou): marque intro como vista
                              onPressed: () => context.go('/login'),
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
