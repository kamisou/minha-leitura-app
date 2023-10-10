import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reading/classes/data/repositories/class_repository.dart';
import 'package:reading/ranking/data/dtos/ranking_filter_dto.dart';

class RankingFilterDialog extends ConsumerWidget {
  const RankingFilterDialog({
    super.key,
    this.filter,
  });

  final RankingFilterDTO? filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        child: ref.watch(myClassesProvider).maybeWhen(
              orElse: () => const Center(
                child: CircularProgressIndicator(),
              ),
              data: (data) => const SingleChildScrollView(
                child: // TODO: corrigir filtro
                    SizedBox(),
              ),
            ),
      ),
    );
  }
}
