import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/common/custom_color.dart';
import 'package:itsukaji_flutter/models/task.dart';
import 'package:itsukaji_flutter/presentation/components/task_card_content.dart';
import 'package:itsukaji_flutter/presentation/components/task_card_edge.dart';
import 'package:itsukaji_flutter/presentation/pages/edit_task_page.dart';
import 'package:itsukaji_flutter/repositories/tasks_repository.dart';

class TaskCard extends StatelessWidget {
  const TaskCard(this.task, {super.key});

  final Task task;

  @override
  Widget build(final BuildContext context) {
    // TODO: カードの裏側にGood Jobアイコンを隠しておく。スライドした時に見えるようにし、カードが消えると同時に消える。
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return EditTaskPage(task);
        }));
      },
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          TasksRepository().setTaskDone(task).then(
                (_) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Good Job!'),
                  ),
                ),
              );
        },
        child: Card(
          elevation: 2,
          color: _cardColor(task),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TaskCardContent(task),
              TaskCardEdge(task),
            ],
          ),
        ),
      ),
    );
  }

  Color _cardColor(final Task thisTask) {
    if (thisTask.isDueToday) {
      return CustomColor.dueToday;
    } else if (thisTask.isDueTomorrow) {
      return CustomColor.dueTomorrow;
    } else {
      return CustomColor.dueLater;
    }
  }
}
