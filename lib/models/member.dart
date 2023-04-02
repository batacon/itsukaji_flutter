import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';

@freezed
class Member with _$Member {
  const factory Member({
    required String id,
    required String name,
    required String groupId,
  }) = _Member;

  factory Member.fromFirestore(final DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Member(
      id: snapshot.id,
      name: data['name'],
      groupId: data['group_id'],
    );
  }
}
