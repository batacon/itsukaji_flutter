import 'package:firebase_auth/firebase_auth.dart';
import 'package:itsukaji_flutter/common/firebase_firestore.dart';
import 'package:itsukaji_flutter/models/member.dart';

class MembersRepository {
  Future<Member> getCurrentMember() async {
    final document = await db.collection("users").where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    return Member.fromFirestore(document.docs.first);
  }

  Future<Member?> findMemberById(String id) async {
    final document = await db.collection("users").where("id", isEqualTo: id).get();
    return document.docs.isEmpty ? null : Member.fromFirestore(document.docs.first);
  }

  Future<List<Member>> getMembersOf(String groupId) async {
    final document = await db.collection("users").where("group_id", isEqualTo: groupId).get();
    return document.docs.map((doc) => Member.fromFirestore(doc)).toList();
  }

  Future<void> createMember(User firebaseUser, String groupId) async {
    await db.collection("users").add({
      "id": firebaseUser.uid,
      "name": firebaseUser.displayName,
      "group_id": groupId,
    });
  }

  Future<void> updateMemberGroup(Member member, String groupId) async {
    await db.collection("users").doc(member.id).update({'group_id': groupId});
  }
}
