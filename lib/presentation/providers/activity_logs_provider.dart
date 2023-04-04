import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/models/activity_log.dart';
import 'package:itsukaji_flutter/models/activity_type.dart';
import 'package:itsukaji_flutter/models/member.dart';
import 'package:itsukaji_flutter/models/task.dart';
import 'package:itsukaji_flutter/presentation/providers/me_provider.dart';

final activityLogsProvider = StateNotifierProvider.autoDispose<ActivityLogsProvider, List<ActivityLog>>((ref) {
  return ActivityLogsProvider(
    ref.watch(meProvider),
  );
});

class ActivityLogsProvider extends StateNotifier<List<ActivityLog>> {
  final Member me;

  ActivityLogsProvider(
    this.me,
  ) : super([]);

  void doneTaskActivityLog(final Task task) {
    state = [
      ...state,
      ActivityLog(
        taskId: task.id,
        memberId: me.id,
        type: ActivityType.done,
        date: DateTime.now(),
      )
    ];
  }

  void addActivityLog(final ActivityLog activityLog) {
    state = [...state, activityLog];
  }

  void removeActivityLog(final ActivityLog activityLog) {
    state = state.where((log) => log != activityLog).toList();
  }

  void updateActivityLog(final ActivityLog activityLog) {
    state = state.map((log) => log == activityLog ? activityLog : log).toList();
  }

  void clearActivityLogs() {
    state = [];
  }

  void setActivityLogs(final List<ActivityLog> activityLogs) {
    state = activityLogs;
  }
}
