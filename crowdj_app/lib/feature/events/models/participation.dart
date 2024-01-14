import 'package:freezed_annotation/freezed_annotation.dart';

part 'participation.freezed.dart';
part 'participation.g.dart';

@freezed
class Participation with _$Participation {
  static const String collectionName = 'participations';

  const factory Participation({
    required String eventId,
    required String userId,
    required DateTime joinedAt,
  }) = _Participation;

  factory Participation.fromJson(Map<String, dynamic> json) =>
      _$ParticipationFromJson(json);
}
