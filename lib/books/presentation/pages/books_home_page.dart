import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class BooksHomePage extends StatelessWidget {
  const BooksHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _books(context),
        ),
        const SizedBox(height: 84),
      ],
    );
  }

  Widget _books(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Lendo agora',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
          textAlign: TextAlign.center,
        ),
        RichText(
          text: TextSpan(
            text: 'você está lendo ',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).textTheme.headlineSmall?.color,
                ),
            children: const [
              TextSpan(
                text: '3 livros',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              TextSpan(text: ' no momento.'),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 42),
        SizedBox(
          height: 330,
          child: PageView.builder(
            itemCount: 3,
            controller: PageController(
              viewportFraction: 0.68,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: AspectRatio(
                aspectRatio: 0.7,
                child: Center(
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Image.network(
                      'https://www.figma.com/file/DY2pcJWrZ2CyHYk4zHtHnF/image/fc51937048b40648284f72d5ba23eb7f53b20da8?fuid=918550331742884956',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: Stack(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.2),
                  shape: const StadiumBorder(),
                ),
                width: 100,
                height: 6,
              ),
              Positioned(
                left: 0,
                width: 75,
                height: 6,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Alice no País das Maravilhas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF3B4149),
                fontWeight: FontWeight.w700,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _noBooks(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: 'Seja bem-vindo ao\n',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
              children: const [
                TextSpan(
                  text: 'Minha Leitura',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          const SvgPicture(
            AssetBytesLoader('assets/vectors/compiled/home-1.svg.vec'),
          ),
          const SizedBox(height: 24),
          Text(
            'Que tal iniciar uma\n'
            'leitura agora mesmo?',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Cadastrar seu primeiro livro para gerenciar o\n'
            'progresso de leitura, fazer anotações e muito mais!',
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Center(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Cadastre um Livro'),
            ),
          ),
        ],
      ),
    );
  }
}
