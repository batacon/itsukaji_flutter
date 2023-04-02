import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itsukaji_flutter/models/task.dart';

class TaskCardContent extends StatelessWidget {
  const TaskCardContent({required this.task, final Key? key}) : super(key: key);

  final Task task;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(task.intervalDays),
          const SizedBox(height: 8),
          _buildTaskName(task.name),
          const SizedBox(height: 8),
          _buildCardFooter(task),
        ],
      ),
    );
  }

  Widget _buildCardHeader(final int intervalDays) {
    return Text(
      'every $intervalDays days',
      style: const TextStyle(
        fontSize: 12,
        decoration: TextDecoration.underline,
      ),
    );
  }

  Widget _buildTaskName(final String name) {
    return Text(
      name,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Row _buildCardFooter(final Task task) {
    final dueDayLabel = task.isOverdue ? '${task.daysOverdue} 日放置中' : 'あと${task.daysUntilNext} 日';
    return Row(
      children: [
        const SizedBox(width: 16),
        _buildIcon('icon_bell_ring'),
        const SizedBox(width: 4),
        Text(dueDayLabel, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 16),
        _buildIcon('icon_calendar_check'),
        const SizedBox(width: 4),
        Text('前回 ${task.lastDoneDateFormatted}', style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildIcon(final String iconName) {
    return SvgPicture.asset(
      'assets/icons/$iconName.svg',
      width: 16,
      height: 16,
    );
  }
}
