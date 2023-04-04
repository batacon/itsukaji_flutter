import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:itsukaji_flutter/models/activity_type.dart';

part 'activity_log.freezed.dart';
part 'activity_log.g.dart';

@freezed
class ActivityLog with _$ActivityLog {
  factory ActivityLog({
    required String taskId,
    required String memberId,
    required ActivityType type,
    required DateTime date,
  }) = _ActivityLog;

  factory ActivityLog.fromJson(Map<String, dynamic> json) => _$ActivityLogFromJson(json);
}
