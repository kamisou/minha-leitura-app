import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/common/extensions/color_extension.dart';

class NewReadingDialog extends HookWidget {
  const NewReadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = useState(const Pages());

    return Column(
      children: [
        Text(
          'Lançar Leitura',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorExtension?.gray[800],
              ),
        ),
        const SizedBox(height: 20),
        Text(
          'Informe o número da página que você parou',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorExtension?.gray[500],
              ),
        ),
        const SizedBox(height: 48),
        TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '00',
            hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorExtension?.gray[300],
                ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
          onChanged: (value) => pages.value = Pages.fromString(value),
          validator: (value) => switch (Pages.validate(value)) {
            PagesError.empty => 'Informe o número de páginas',
            PagesError.invalid => 'Informe um número de páginas válido',
            _ => null,
          },
        ),
        const SizedBox(height: 100),
        Row(
          children: [
            TextButton(
              onPressed: context.pop,
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => context.pop(pages),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ],
    );
  }
}
