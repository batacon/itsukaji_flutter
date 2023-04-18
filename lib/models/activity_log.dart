import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:itsukaji_flutter/models/activity_type.dart';

part 'activity_log.freezed.dart';
part 'activity_log.g.dart';

@freezed
class ActivityLog with _$ActivityLog {
  const ActivityLog._();

  factory ActivityLog({
    required String taskId,
    required String taskName,
    required String memberId,
    required String memberName,
    required ActivityType type,
    required DateTime date,
  }) = _ActivityLog;

  factory ActivityLog.fromJson(Map<String, dynamic> json) => _$ActivityLogFromJson(json);

  String get formattedDate => '${date.year}/${date.month}/${date.day}';

  String get formattedTime => '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
