import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/components/task_edit_form.dart';
import 'package:itsukaji_flutter/models/task.dart';

class EditTaskPage extends StatelessWidget {
  const EditTaskPage({required this.task, Key? key}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit New Task'),
        elevation: 0,
      ),
      body: Column(
        children: [
          TaskEditForm(task: task),
        ],
      ),
    );
  }
}
