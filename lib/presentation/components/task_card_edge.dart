import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/models/task.dart';

class TaskCardEdge extends StatelessWidget {
  const TaskCardEdge({required this.task, Key? key}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 92,
      color: _cardEdgeColor(task),
    );
  }

  Color _cardEdgeColor(Task thisTask) {
    if (thisTask.isDueToday()) {
      return const Color(0xFFF5BECF);
    } else if (thisTask.isDueTomorrow()) {
      return const Color(0xFFFFF7A0);
    } else {
      return const Color(0xFFBBE2F1);
    }
  }
}
