import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';

@freezed
class Group with _$Group {
  const factory Group({
    required String id,
    required String invitationCode,
  }) = _Group;

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
