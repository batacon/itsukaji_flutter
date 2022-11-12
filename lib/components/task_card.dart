import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itsukaji_flutter/models/task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFDF5F9),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'every ${task.intervalDays} days',
              style: const TextStyle(
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              task.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const SizedBox(width: 16),
                SvgPicture.asset(
                  'assets/icons/icon_bell_ring.svg',
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 4),
                Text('あと${task.daysUntilNext()} 日', style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  'assets/icons/icon_calendar_check.svg',
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 4),
                Text('前回 ${task.lastDoneDateFormatted()}', style: const TextStyle(fontSize: 14)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
