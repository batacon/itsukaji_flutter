import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/common/firebase_firestore.dart';
import 'package:itsukaji_flutter/models/group.dart';
import 'package:itsukaji_flutter/models/invitation_code.dart';

final groupsRepositoryProvider = Provider.autoDispose<GroupsRepository>((ref) {
  return GroupsRepository();
});

class GroupsRepository {
  Group? _currentGroup;

  Future<Group> fetchCurrentGroup() async {
    if (_currentGroup != null) return _currentGroup!;

    final userDocument = await db.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    final groupId = userDocument.get("group_id");
    final groupDocument = await db.collection("groups").doc(groupId).get();
    _currentGroup = Group.fromFirestore(groupDocument);
    return _currentGroup!;
  }

  Future<Group?> getGroupByInvitationCode(final String invitationCode) async {
    final document = await db.collection("groups").where("invitation_code", isEqualTo: invitationCode).get();
    if (document.docs.isEmpty) return null;
    return Group.fromFirestore(document.docs.first);
  }

  Future<void> regenerateInvitationCode() async {
    final currentGroup = await fetchCurrentGroup();
    final invitationCode = InvitationCode.generate();
    await db.collection("groups").doc(currentGroup.id).update({"invitation_code": invitationCode});
    _currentGroup = currentGroup.copyWith(invitationCode: invitationCode);
  }

  Future<Group> createGroup() async {
    final newGroupReference = await db.collection("groups").add({"invitation_code": InvitationCode.generate()});
    final documentSnapshot = await newGroupReference.get();
    return Group.fromFirestore(documentSnapshot);
  }

  Future<void> deleteCurrentGroup() async {
    final currentGroup = await fetchCurrentGroup();
    await db.collection("groups").doc(currentGroup.id).delete();
  }
}
