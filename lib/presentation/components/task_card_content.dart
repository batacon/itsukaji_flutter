import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itsukaji_flutter/models/task.dart';

class TaskCardContent extends StatelessWidget {
  const TaskCardContent({required this.task, Key? key}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(task.intervalDays),
          const SizedBox(height: 8),
          _buildTaskName(task.name),
          const SizedBox(height: 8),
          _buildCardFooter(daysUntilNext: task.daysUntilNext(), lastDoneDate: task.lastDoneDateFormatted()),
        ],
      ),
    );
  }

  Widget _buildCardHeader(int intervalDays) {
    return Text(
      'every $intervalDays days',
      style: const TextStyle(
        fontSize: 12,
        decoration: TextDecoration.underline,
      ),
    );
  }

  Widget _buildTaskName(String name) {
    return Text(
      name,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Row _buildCardFooter({required int daysUntilNext, required String lastDoneDate}) {
    return Row(
      children: [
        const SizedBox(width: 16),
        _buildIcon('icon_bell_ring'),
        const SizedBox(width: 4),
        Text('あと$daysUntilNext 日', style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 16),
        _buildIcon('icon_calendar_check'),
        const SizedBox(width: 4),
        Text('前回 $lastDoneDate', style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildIcon(String iconName) {
    return SvgPicture.asset(
      'assets/icons/$iconName.svg',
      width: 16,
      height: 16,
    );
  }
}
