import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itsukaji_flutter/models/task.dart';

class TaskCardContent extends StatelessWidget {
  const TaskCardContent(this.task, {super.key});

  final Task task;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(context, task.intervalDays),
            const SizedBox(height: 8),
            _buildTaskName(context, task.name),
            const SizedBox(height: 8),
            _buildCardFooter(context, task),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(final BuildContext context, final int intervalDays) {
    return Text(
      'every $intervalDays days',
      style: Theme.of(context).textTheme.titleSmall,
    );
  }

  Widget _buildTaskName(final BuildContext context, final String name) {
    return Text(
      name,
      style: Theme.of(context).textTheme.displayMedium,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Row _buildCardFooter(final BuildContext context, final Task task) {
    final dueDayLabel = task.isOverdue ? '${task.daysOverdue} 日放置中' : 'あと${task.daysUntilNext} 日';
    return Row(
      children: [
        const SizedBox(width: 16),
        _buildIcon('icon_bell_ring'),
        const SizedBox(width: 4),
        Text(dueDayLabel, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 16),
        _buildIcon('icon_calendar_check'),
        const SizedBox(width: 4),
        Text('前回 ${task.lastDoneDateFormatted}', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildIcon(final String iconName) {
    return SvgPicture.asset('assets/icons/$iconName.svg', width: 16, height: 16);
  }
}
