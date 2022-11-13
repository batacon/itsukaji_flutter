import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/models/task.dart';
import 'package:itsukaji_flutter/presentation/components/task_card_content.dart';
import 'package:itsukaji_flutter/presentation/components/task_card_edge.dart';
import 'package:itsukaji_flutter/presentation/pages/edit_task_page.dart';
import 'package:itsukaji_flutter/repositories/tasks_repository.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({required this.task, Key? key}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    // TODO: カードの裏側にGood Jobアイコンを隠しておく。スライドした時に見えるようにし、カードが消えると同時に消える。
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return EditTaskPage(task: task);
        }));
      },
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          TaskRepository().setTaskDone(task).then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Good Job!'),
                  ),
                ),
              );
        },
        child: Card(
          elevation: 2,
          color: _cardColor(task),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TaskCardContent(task: task),
              TaskCardEdge(task: task),
            ],
          ),
        ),
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
