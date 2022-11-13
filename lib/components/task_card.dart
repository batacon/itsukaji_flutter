import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/components/task_card_content.dart';
import 'package:itsukaji_flutter/components/task_card_edge.dart';
import 'package:itsukaji_flutter/models/task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: _cardColor(task),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TaskCardContent(task: task),
          TaskCardEdge(task: task),
        ],
      ),
    );
  }

  Color _cardColor(Task thisTask) {
    if (thisTask.isDueToday()) {
      return const Color(0xFFFDF5F9);
    } else if (thisTask.isDueTomorrow()) {
      return const Color(0xFFFFFEF1);
    } else {
      return const Color(0xFFF3F9FD);
    }
  }
}
