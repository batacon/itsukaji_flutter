import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/models/member.dart';
import 'package:itsukaji_flutter/models/task.dart';
import 'package:itsukaji_flutter/presentation/components/task_card.dart';
import 'package:itsukaji_flutter/presentation/pages/create_task_page.dart';
import 'package:itsukaji_flutter/repositories/members_repository.dart';
import 'package:itsukaji_flutter/repositories/tasks_repository.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _tasksRepository = TasksRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('itsukaji'),
        centerTitle: true,
        elevation: 0,
        // TODO: ハンバーガーメニューを追加する
      ),
      body: _buildTaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const CreateTaskPage();
          }));
        },
        tooltip: 'Create New Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList() {
    return FutureBuilder(
      future: MembersRepository().getCurrentMember(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final currentMember = snapshot.data as Member;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: _tasksRepository.getTasks(currentMember),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 16),
                      ..._sortTasksByDaysUntilNext(snapshot.data!.docs).map((QueryDocumentSnapshot document) {
                        final documentData = document as QueryDocumentSnapshot<Map<String, dynamic>>;
                        final task = Task.fromFirestore(documentData);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: TaskCard(task: task),
                        );
                      }).toList(),
                      const SizedBox(height: 52),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          );
        } else {
          return const Center(child: Text('家事を作ろう'));
        }
      },
    );
  }

  List<QueryDocumentSnapshot<Object?>> _sortTasksByDaysUntilNext(List<QueryDocumentSnapshot<Object?>> documents) {
    documents.sort((a, b) {
      final aTask = Task.fromFirestore(a as QueryDocumentSnapshot<Map<String, dynamic>>);
      final bTask = Task.fromFirestore(b as QueryDocumentSnapshot<Map<String, dynamic>>);
      return aTask.daysUntilNext().compareTo(bTask.daysUntilNext());
    });
    return documents;
  }
}

// ElevatedButton(
//   onPressed: () {
//     FirebaseAuth.instance.signOut();
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => const SignInPage()),
//     );
//   },
//   child: const Text('Sign Out'),
// ),
