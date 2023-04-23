import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/common/custom_color.dart';
import 'package:itsukaji_flutter/common/show_snack_bar_with_text.dart';
import 'package:itsukaji_flutter/models/activity_log.dart';
import 'package:itsukaji_flutter/presentation/pages/edit_task_page.dart';
import 'package:itsukaji_flutter/repositories/tasks_repository.dart';

class ActivityLogCard extends ConsumerWidget {
  final ActivityLog _activityLog;

  const ActivityLogCard(this._activityLog, {super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return InkWell(
      onTap: () {
        try {
          ref.watch(tasksRepositoryProvider).findTaskById(_activityLog.taskId).then((task) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return EditTaskPage(task);
            }));
          });
        } catch (e) {
          showSnackBarWithText(context, 'タスクが見つかりませんでした。');
        }
      },
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActivityLogCardContent(context),
            _buildActivityLogCardEdge(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityLogCardContent(final BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_activityLog.memberName}さんが',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  _activityLog.formattedTime,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _activityLog.taskName,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: CustomColor.primary),
            ),
            const SizedBox(height: 8),
            Text(
              'をしてくれました！',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityLogCardEdge(final BuildContext context) {
    return Container(
      width: 24,
      height: 119,
      color: CustomColor.primary,
    );
  }
}
