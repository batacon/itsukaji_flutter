import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/models/activity_type.dart';
import 'package:itsukaji_flutter/models/task.dart';
import 'package:itsukaji_flutter/presentation/providers/activity_logs_provider.dart';
import 'package:itsukaji_flutter/repositories/tasks_repository.dart';

final taskListProvider = StateNotifierProvider.autoDispose<TaskListProvider, List<Task>>((ref) {
  return TaskListProvider(
    ref.watch(tasksRepositoryProvider),
    ref.watch(activityLogsProvider.notifier),
  );
});

class TaskListProvider extends StateNotifier<List<Task>> {
  final TasksRepository _tasksRepository;
  final ActivityLogsProvider _activityLogsProvider;

  TaskListProvider(
    this._tasksRepository,
    this._activityLogsProvider,
  ) : super([]);

  Future<void> doneTask(final Task task) async {
    _tasksRepository.setTaskDone(task);
    _activityLogsProvider.addActivityLog(task, ActivityType.done);
  }
}
