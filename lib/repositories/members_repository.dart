import 'package:firebase_auth/firebase_auth.dart';
import 'package:itsukaji_flutter/common/firebase_firestore.dart';
import 'package:itsukaji_flutter/models/member.dart';

class MembersRepository {
  Future<Member> getCurrentMember() async {
    final document = await db.collection("users").where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    return Member.fromFirestore(document.docs.first);
  }
}
