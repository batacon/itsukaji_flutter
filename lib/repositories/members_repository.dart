import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/common/firebase_firestore.dart';
import 'package:itsukaji_flutter/models/member.dart';

final membersRepositoryProvider = Provider.autoDispose<MembersRepository>((ref) {
  return MembersRepository();
});

class MembersRepository {
  Member? currentMember;

  Future<Member> getCurrentMember() async {
    if (currentMember != null) return currentMember!;

    final document = await db.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    currentMember = Member.fromFirestore(document);
    return currentMember!;
  }

  Future<Member?> findMemberById(final String id) async {
    final document = await db.collection('users').doc(id).get();
    return document.exists ? Member.fromFirestore(document) : null;
  }

  Future<List<Member>> getMembersOf(final String groupId) async {
    final document = await db.collection("users").where("group_id", isEqualTo: groupId).get();
    return document.docs.map((final doc) => Member.fromFirestore(doc)).toList();
  }

  Future<void> updateNickname(final String nickname) async {
    await db.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({'name': nickname});
  }

  Future<void> createMember(final User firebaseUser, final String groupId) async {
    await db.collection("users").doc(firebaseUser.uid).set({
      "name": firebaseUser.displayName,
      "group_id": groupId,
    });
  }

  Future<void> updateMemberGroup(final Member member, final String groupId) async {
    await db.collection("users").doc(member.id).update({'group_id': groupId});
  }

  Future<void> removeMember(final String memberId) async {
    await db.collection("users").doc(memberId).delete();
  }
}
