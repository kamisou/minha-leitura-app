import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reading/common/infrastructure/rest_api.dart';

part 'book_details.freezed.dart';
part 'book_details.g.dart';

@freezed
class BookDetails with _$BookDetails {
  const factory BookDetails({
    required int pageCount,
    required int pagesRead,
    required int currentPage,
    required int dailyPageGoal,
    required DateTime started,
  }) = _BookDetails;

  const BookDetails._();

  factory BookDetails.fromJson(Json json) => _$BookDetailsFromJson(json);

  DateTime get expectedEnding =>
      started.add(Duration(days: pageCount ~/ dailyPageGoal));

  Duration get remainingDays => expectedEnding.difference(started);
}
