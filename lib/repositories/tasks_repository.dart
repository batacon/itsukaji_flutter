import 'package:itsukaji_flutter/common/firebase_firestore.dart';
import 'package:itsukaji_flutter/models/member.dart';
import 'package:itsukaji_flutter/models/task.dart';
import 'package:itsukaji_flutter/repositories/members_repository.dart';

class TasksRepository {
  Stream<List<Task>> getTasks(Member currentMember) {
    final snapshot = db.collection('groups').doc(currentMember.groupId).collection("tasks").snapshots();
    return snapshot.map((snapshot) => snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList());
  }

  Future<void> addTask(Map<String, dynamic> taskForm) async {
    final currentMember = await MembersRepository().getCurrentMember();
    await db.collection('groups').doc(currentMember.groupId).collection("tasks").add(taskForm);
  }

  Future<void> setTaskDone(Task task) async {
    final currentMember = await MembersRepository().getCurrentMember();
    await db
        .collection('groups')
        .doc(currentMember.groupId)
        .collection("tasks")
        .doc(task.id)
        .update({"lastDoneDate": DateTime.now()});
  }

  Future<void> updateTask(Task task) async {
    final currentMember = await MembersRepository().getCurrentMember();
    await db.collection('groups').doc(currentMember.groupId).collection("tasks").doc(task.id).update(task.toJson());
  }

  Future<void> removeTask(String taskId) async {
    final currentMember = await MembersRepository().getCurrentMember();
    await db.collection('groups').doc(currentMember.groupId).collection("tasks").doc(taskId).delete();
  }
}
