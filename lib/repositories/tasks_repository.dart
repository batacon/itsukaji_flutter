import 'package:firebase_auth/firebase_auth.dart';
import 'package:itsukaji_flutter/firebase_firestore.dart';
import 'package:itsukaji_flutter/models/task.dart';

class TaskRepository {
  void getTasks() async {
    final snapshot =
        await db.collection("tasks").where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    print(snapshot.docs);
  }

  void addTask(Task task) {}

  // void removeTask(Task task) {
  //   _tasks.remove(task);
  // }
}
