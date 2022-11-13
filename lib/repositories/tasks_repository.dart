import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itsukaji_flutter/common/firebase_firestore.dart';
import 'package:itsukaji_flutter/models/task.dart';

class TaskRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> getTasks() {
    // TODO: 連携ユーザーのタスクも取得する
    // TODO: グループに紐付ける。トーク画面のような実装を参考にする
    return db.collection("tasks").where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
  }

  Future<void> addTask(Map<String, dynamic> taskForm) async {
    await db.collection("tasks").add(taskForm);
  }

  Future<void> setTaskDone(Task task) async {
    await db.collection("tasks").doc(task.id).update({"lastDoneDate": DateTime.now()});
  }

  Future<void> updateTask(Task task) async {
    await db.collection("tasks").doc(task.id).update(task.toJson());
  }

  Future<void> removeTask(String taskId) async {
    await db.collection("tasks").doc(taskId).delete();
  }
}
