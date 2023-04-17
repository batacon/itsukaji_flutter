import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/models/activity_log.dart';
import 'package:itsukaji_flutter/presentation/components/activity_log_card.dart';

class ActivityLogsByDateSection extends StatelessWidget {
  final String _date;
  final List<ActivityLog> _activityLogs;

  const ActivityLogsByDateSection(this._date, this._activityLogs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateHeader(context),
        const SizedBox(height: 20),
        _buildActivityLogList(context),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildDateHeader(BuildContext context) {
    return Text(
      _date,
      style: Theme.of(context).textTheme.displayMedium,
    );
  }

  Widget _buildActivityLogList(BuildContext context) {
    return Column(
      children: _activityLogs.map((activityLog) => ActivityLogCard(activityLog)).toList(),
    );
  }
}
