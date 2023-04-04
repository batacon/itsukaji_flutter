import 'package:itsukaji_flutter/common/firebase_firestore.dart';
import 'package:itsukaji_flutter/models/activity_log.dart';

class ActivityLogsRepository {
  Future<List<ActivityLog>> getActivityLogs(final String groupId) async {
    final querySnapshot = await db.collection('groups').doc(groupId).collection('activity_logs').get();

    return querySnapshot.docs.map((doc) => ActivityLog.fromJson(doc.data())).toList();
  }

  Future<void> addActivityLog(final String groupId, final ActivityLog activityLog) async {
    await db.collection('groups').doc(groupId).collection('activity_logs').add(activityLog.toJson());
  }
}
