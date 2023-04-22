import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/models/activity_log.dart';
import 'package:itsukaji_flutter/models/activity_type.dart';
import 'package:itsukaji_flutter/models/task.dart';
import 'package:itsukaji_flutter/repositories/activity_logs_repository.dart';

final activityLogsProvider = StateNotifierProvider.autoDispose<ActivityLogsProvider, List<ActivityLog>>((ref) {
  return ActivityLogsProvider(
    ref.watch(activityLogsRepositoryProvider),
  );
});

class ActivityLogsProvider extends StateNotifier<List<ActivityLog>> {
  final ActivityLogsRepository _activityLogsRepository;

  ActivityLogsProvider(
    this._activityLogsRepository,
  ) : super([]) {
    _init();
  }

  bool get hasActivityLogs => state.isNotEmpty;

  int get activityLogDateCount => _activityLogsByDate.length;

  Map<String, List<ActivityLog>> get _activityLogsByDate {
    return groupBy(state, (activityLog) => activityLog.formattedDate);
  }

  Iterable<MapEntry<String, List<ActivityLog>>> get activityLogEntries {
    return _activityLogsByDate.entries.sorted((a, b) => b.value[0].date.compareTo(a.value[0].date));
  }

  Future<void> addActivityLog(final Task task, final ActivityType type) async {
    final newActivityLog = await _activityLogsRepository.addActivityLog(task, type);
    state = [...state, newActivityLog];
  }

  Future<void> _init() async {
    state = await _activityLogsRepository.getActivityLogs();
  }
}
