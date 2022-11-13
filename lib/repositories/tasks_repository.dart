import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itsukaji_flutter/firebase_firestore.dart';
import 'package:itsukaji_flutter/models/task.dart';

class TaskRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> getTasks() {
    return db.collection("tasks").where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
  }

  Future addTask(Map<String, dynamic> taskForm) async {
    await db.collection("tasks").add(taskForm);
  }

  Future setTaskDone(Task task) async {
    await db.collection("tasks").doc(task.id).update({"lastDoneDate": DateTime.now()});
  }

  Future updateTask(Task task) async {
    await db.collection("tasks").doc(task.id).update(task.toJson());
  }

  // void removeTask(Task task) {
  //   _tasks.remove(task);
  // }
}
