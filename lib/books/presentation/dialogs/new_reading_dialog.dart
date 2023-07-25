import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reading/books/domain/value_objects/pages.dart';
import 'package:reading/common/presentation/theme_extension.dart';

class NewReadingDialog extends HookWidget {
  const NewReadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = useState(const Pages());

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Lançar Leitura',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorExtension?.gray[800],
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Informe o número da página que você parou',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorExtension?.gray[500],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: false,
              hintText: '00',
              hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorExtension?.gray[300],
                    fontSize: 52,
                  ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
            onChanged: (value) => pages.value = Pages.fromString(value),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorExtension?.gray[600],
                  fontSize: 52,
                ),
            validator: (value) => switch (Pages.validate(value)) {
              PagesError.empty => 'Informe o número de páginas',
              PagesError.invalid => 'Informe um número de páginas válido',
              _ => null,
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: context.pop,
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: () => context.pop(pages),
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          ),
        ],
      ),
    );
  }
}
