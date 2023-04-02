import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  Member({
    required this.id,
    required this.name,
    required this.groupId,
  });

  final String id;
  final String name;
  final String groupId;

  factory Member.fromFirestore(final DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Member(
      id: snapshot.id,
      name: data['name'],
      groupId: data['group_id'],
    );
  }
}
