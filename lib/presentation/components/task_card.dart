import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/common/custom_color.dart';
import 'package:itsukaji_flutter/common/show_snack_bar_with_text.dart';
import 'package:itsukaji_flutter/models/task.dart';
import 'package:itsukaji_flutter/presentation/components/task_card_content.dart';
import 'package:itsukaji_flutter/presentation/components/task_card_edge.dart';
import 'package:itsukaji_flutter/presentation/pages/edit_task_page.dart';
import 'package:itsukaji_flutter/presentation/providers/task_list_provider.dart';

class TaskCard extends ConsumerWidget {
  const TaskCard(this.task, {super.key});

  final Task task;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
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
          ref.read(taskListProvider.notifier).doneTask(task).then(
                (_) => showSnackBarWithText(context, '${task.name}を完了しました!'),
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
