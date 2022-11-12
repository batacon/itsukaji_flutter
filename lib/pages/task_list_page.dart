import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/components/task_card.dart';
import 'package:itsukaji_flutter/firebase_firestore.dart';
import 'package:itsukaji_flutter/models/task.dart';
import 'package:itsukaji_flutter/pages/create_task_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('itsukaji'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: db.collection('tasks').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                shrinkWrap: true,
                children: _sortTasksByDaysUntilNext(snapshot.data!.docs).map((QueryDocumentSnapshot document) {
                  final documentData = document as QueryDocumentSnapshot<Map<String, dynamic>>;
                  final task = Task.fromFirestore(documentData, null);
                  return TaskCard(task: task);
                }).toList(),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
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

  List<QueryDocumentSnapshot<Object?>> _sortTasksByDaysUntilNext(List<QueryDocumentSnapshot<Object?>> documents) {
    documents.sort((a, b) {
      final aTask = Task.fromFirestore(a as QueryDocumentSnapshot<Map<String, dynamic>>, null);
      final bTask = Task.fromFirestore(b as QueryDocumentSnapshot<Map<String, dynamic>>, null);
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
