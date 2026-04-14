import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/ranking/data/cached/book_ranking.dart';
import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';
import 'package:reading/ranking/domain/models/ranking.dart';
import 'package:reading/ranking/presentation/dialogs/ranking_filter_dialog.dart';
import 'package:reading/ranking/presentation/tabs/book_ranking_tab.dart';
import 'package:reading/ranking/presentation/tabs/book_reading_ranking_tab.dart';
import 'package:reading/shared/presentation/hooks/use_asyncvalue_listener.dart';
import 'package:reading/shared/presentation/hooks/use_filter_name.dart';
import 'package:reading/shared/presentation/widgets/user_app_bar.dart';
import 'package:reading/shared/util/theme_data_extension.dart';

class BookRankingPage extends HookConsumerWidget {
  const BookRankingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = useState(const RankingFilterDTO(type: RankingType.global));
    final filterName = useFilterName(filter.value.type, filter.value.$class);
    final controller = useTabController(initialLength: 2);

    useAutomaticKeepAlive();
    useAsyncValueListener(ref, bookRankingProvider(filter.value));

    return Column(
      children: [
        const UserAppBar(),
        Expanded(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Ranking de Livros',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 8),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Acompanhe o ranking dos livros mais bem avaliados '
                    'e os mais lidos',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorExtension?.gray[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: FilledButton.icon(
                    onPressed: () => showDialog<RankingFilterDTO?>(
                      context: context,
                      builder: (context) => RankingFilterDialog(
                        initialState: filter.value,
                      ),
                    ).then(
                      (value) => value != null //
                          ? filter.value = value
                          : null,
                    ),
                    icon: const Icon(FeatherIcons.filter),
                    label: const Text('Filtrar'),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
              SliverToBoxAdapter(
                child: Text(
                  filterName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              SliverToBoxAdapter(
                child: TabBar(
                  controller: controller,
                  labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorExtension?.gray[800],
                        fontWeight: FontWeight.w700,
                      ),
                  splashFactory: NoSplash.splashFactory,
                  unselectedLabelStyle:
                      Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorExtension?.gray[600],
                          ),
                  tabs: const [
                    Tab(text: 'Avaliação'),
                    Tab(text: 'Leitura'),
                  ],
                ),
              ),
            ],
            body: RefreshIndicator(
              onRefresh: () =>
                  ref.refresh(bookRankingProvider(filter.value).future),
              child: TabBarView(
                controller: controller,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BookRankingTab(filter: filter.value),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BookReadingRankingTab(filter: filter.value),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
