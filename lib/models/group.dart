import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String id;
  final String invitationCode;

  Group({
    required this.id,
    required this.invitationCode,
  });

  factory Group.fromFirestore(final DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    final group = Group(
      id: document.id,
      invitationCode: data['invitation_code'],
    );
    return group;
  }

// get members => _members;
}
