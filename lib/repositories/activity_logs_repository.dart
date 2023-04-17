import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/common/firebase_firestore.dart';
import 'package:itsukaji_flutter/models/activity_log.dart';
import 'package:itsukaji_flutter/models/activity_type.dart';
import 'package:itsukaji_flutter/models/task.dart';
import 'package:itsukaji_flutter/repositories/members_repository.dart';

final activityLogsRepositoryProvider = Provider.autoDispose<ActivityLogsRepository>((ref) {
  return ActivityLogsRepository();
});

class ActivityLogsRepository {
  Future<List<ActivityLog>> getActivityLogs() async {
    final currentMember = await MembersRepository().getCurrentMember();
    final groupId = currentMember.groupId;
    final querySnapshot = await db.collection('groups').doc(groupId).collection('activity_logs').get();
    return querySnapshot.docs.map((doc) => ActivityLog.fromJson(doc.data())).toList();
  }

  Future<ActivityLog> addActivityLog(final Task task, final ActivityType type) async {
    final currentMember = await MembersRepository().getCurrentMember();
    final groupId = currentMember.groupId;
    final newActivityLog = ActivityLog(
      taskId: task.id,
      taskName: task.name,
      memberId: currentMember.id,
      memberName: currentMember.name,
      type: type,
      date: DateTime.now(),
    );
    await db.collection('groups').doc(groupId).collection('activity_logs').add(newActivityLog.toJson());
    return newActivityLog;
  }
}
