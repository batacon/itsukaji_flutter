import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String id;
  final String invitationCode;
  final List<String> userIds;

  Group({
    required this.id,
    required this.invitationCode,
    required this.userIds,
  });

  factory Group.fromFirestore(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    final userIds = data['users'].map<String>((e) => e.toString()).toList();
    final group = Group(
      id: document.id,
      invitationCode: data['invitation_code'],
      userIds: userIds,
    );
    return group;
  }

  // get members => _members;
}
