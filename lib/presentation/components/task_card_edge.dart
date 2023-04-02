import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/common/custom_color.dart';
import 'package:itsukaji_flutter/models/task.dart';

class TaskCardEdge extends StatelessWidget {
  const TaskCardEdge(this.task, {super.key});

  final Task task;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: 24,
      height: 98,
      color: _cardEdgeColor(task),
    );
  }

  Color _cardEdgeColor(final Task thisTask) {
    if (thisTask.isDueToday) {
      return CustomColor.dueTodayEdge;
    } else if (thisTask.isDueTomorrow) {
      return CustomColor.dueTomorrowEdge;
    } else {
      return CustomColor.dueLaterEdge;
    }
  }
}
