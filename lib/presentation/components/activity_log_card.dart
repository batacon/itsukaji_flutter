import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/common/custom_color.dart';
import 'package:itsukaji_flutter/models/activity_log.dart';

class ActivityLogCard extends StatelessWidget {
  final ActivityLog _activityLog;

  const ActivityLogCard(this._activityLog, {super.key});

  @override
  Widget build(final BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActivityLogCardContent(context),
          _buildActivityLogCardEdge(context),
        ],
      ),
    );
  }

  Widget _buildActivityLogCardContent(final BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
