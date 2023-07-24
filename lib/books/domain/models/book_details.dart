import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:reading/common/infrastructure/rest_api.dart';

part 'book_details.freezed.dart';
part 'book_details.g.dart';

@freezed
@HiveType(typeId: 5)
class BookDetails extends HiveObject with _$BookDetails {
  const factory BookDetails({
    @HiveField(0) required int id,
    @HiveField(1) required int pageCount,
    @HiveField(2) required int pagesRead,
    @HiveField(3) required int currentPage,
    @HiveField(4) required int dailyPageGoal,
    @HiveField(5) required DateTime started,
  }) = _BookDetails;

  BookDetails._();

  factory BookDetails.fromJson(Json json) => _$BookDetailsFromJson(json);

  DateTime get expectedEnding =>
      started.add(Duration(days: pageCount ~/ dailyPageGoal));

  Duration get remainingDays => expectedEnding.difference(started);
}
