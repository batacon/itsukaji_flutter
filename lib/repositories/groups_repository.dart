import 'package:firebase_auth/firebase_auth.dart';
import 'package:itsukaji_flutter/common/firebase_firestore.dart';
import 'package:itsukaji_flutter/models/group.dart';

class GroupsRepository {
  Future<Group> getCurrentGroup() async {
    final document = await db
        .collection("groups")
        .where(
          "users",
          arrayContains: FirebaseAuth.instance.currentUser!.uid,
        )
        .get();
    return Group.fromFirestore(document.docs.first);
  }
}
