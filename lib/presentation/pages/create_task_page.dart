import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/presentation/components/task_create_form.dart';

class CreateTaskPage extends StatelessWidget {
  const CreateTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Task'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: const [
          TaskCreateForm(),
        ],
      ),
    );
  }
}
