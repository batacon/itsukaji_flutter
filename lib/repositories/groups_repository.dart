import 'package:firebase_auth/firebase_auth.dart';
import 'package:itsukaji_flutter/common/firebase_firestore.dart';
import 'package:itsukaji_flutter/models/group.dart';
import 'package:itsukaji_flutter/models/invitation_code.dart';

class GroupsRepository {
  Future<Group> getCurrentGroup() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userDocument = await db.collection("users").where("id", isEqualTo: currentUser.uid).get();
    final groupId = userDocument.docs.first.get("group_id");
    final groupDocument = await db.collection("groups").doc(groupId).get();
    return Group.fromFirestore(groupDocument);
  }

  Future<Group?> getGroupByInvitationCode(String invitationCode) async {
    final document = await db.collection("groups").where("invitation_code", isEqualTo: invitationCode).get();
    if (document.docs.isEmpty) return null;
    return Group.fromFirestore(document.docs.first);
  }

  Future<Group> createGroup() async {
    final newGroupReference = await db.collection("groups").add({"invitation_code": InvitationCode.generate()});
    return Group.fromFirestore((await newGroupReference.get()));
  }
}
