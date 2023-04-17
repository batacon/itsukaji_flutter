import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/models/task.dart';
import 'package:itsukaji_flutter/presentation/components/task_edit_form.dart';

class EditTaskPage extends StatelessWidget {
  const EditTaskPage(this.task, {super.key});

  final Task task;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          TaskEditForm(task),
        ],
      ),
    );
  }
}
