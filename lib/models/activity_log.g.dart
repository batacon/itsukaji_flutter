// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ActivityLog _$$_ActivityLogFromJson(Map<String, dynamic> json) =>
    _$_ActivityLog(
      taskId: json['taskId'] as String,
      memberId: json['memberId'] as String,
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$_ActivityLogToJson(_$_ActivityLog instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'memberId': instance.memberId,
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'date': instance.date.toIso8601String(),
    };

const _$ActivityTypeEnumMap = {
  ActivityType.done: 'done',
};
