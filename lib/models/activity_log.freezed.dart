// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ActivityLog _$ActivityLogFromJson(Map<String, dynamic> json) {
  return _ActivityLog.fromJson(json);
}

/// @nodoc
mixin _$ActivityLog {
  String get taskId => throw _privateConstructorUsedError;
  String get memberId => throw _privateConstructorUsedError;
  ActivityType get type => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityLogCopyWith<ActivityLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityLogCopyWith<$Res> {
  factory $ActivityLogCopyWith(
          ActivityLog value, $Res Function(ActivityLog) then) =
      _$ActivityLogCopyWithImpl<$Res, ActivityLog>;
  @useResult
  $Res call({String taskId, String memberId, ActivityType type, DateTime date});
}

/// @nodoc
class _$ActivityLogCopyWithImpl<$Res, $Val extends ActivityLog>
    implements $ActivityLogCopyWith<$Res> {
  _$ActivityLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? memberId = null,
    Object? type = null,
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ActivityType,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ActivityLogCopyWith<$Res>
    implements $ActivityLogCopyWith<$Res> {
  factory _$$_ActivityLogCopyWith(
          _$_ActivityLog value, $Res Function(_$_ActivityLog) then) =
      __$$_ActivityLogCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String taskId, String memberId, ActivityType type, DateTime date});
}

/// @nodoc
class __$$_ActivityLogCopyWithImpl<$Res>
    extends _$ActivityLogCopyWithImpl<$Res, _$_ActivityLog>
    implements _$$_ActivityLogCopyWith<$Res> {
  __$$_ActivityLogCopyWithImpl(
      _$_ActivityLog _value, $Res Function(_$_ActivityLog) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? memberId = null,
    Object? type = null,
    Object? date = null,
  }) {
    return _then(_$_ActivityLog(
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ActivityType,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ActivityLog implements _ActivityLog {
  _$_ActivityLog(
      {required this.taskId,
      required this.memberId,
      required this.type,
      required this.date});

  factory _$_ActivityLog.fromJson(Map<String, dynamic> json) =>
      _$$_ActivityLogFromJson(json);

  @override
  final String taskId;
  @override
  final String memberId;
  @override
  final ActivityType type;
  @override
  final DateTime date;

  @override
  String toString() {
    return 'ActivityLog(taskId: $taskId, memberId: $memberId, type: $type, date: $date)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActivityLog &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, taskId, memberId, type, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ActivityLogCopyWith<_$_ActivityLog> get copyWith =>
      __$$_ActivityLogCopyWithImpl<_$_ActivityLog>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ActivityLogToJson(
      this,
    );
  }
}

abstract class _ActivityLog implements ActivityLog {
  factory _ActivityLog(
      {required final String taskId,
      required final String memberId,
      required final ActivityType type,
      required final DateTime date}) = _$_ActivityLog;

  factory _ActivityLog.fromJson(Map<String, dynamic> json) =
      _$_ActivityLog.fromJson;

  @override
  String get taskId;
  @override
  String get memberId;
  @override
  ActivityType get type;
  @override
  DateTime get date;
  @override
  @JsonKey(ignore: true)
  _$$_ActivityLogCopyWith<_$_ActivityLog> get copyWith =>
      throw _privateConstructorUsedError;
}
