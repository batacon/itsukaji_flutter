import 'package:flutter/material.dart';
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
                color: Color(0xFF333333),
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              task.name,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                const SizedBox(width: 16.0),
                Text('あと${task.daysUntilNext()} 日'),
                const SizedBox(width: 8.0),
                Text('前回 ${task.lastDoneDateFormatted()}'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
