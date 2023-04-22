import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/models/group.dart';
import 'package:itsukaji_flutter/repositories/groups_repository.dart';

final currentGroupProvider = StateNotifierProvider.autoDispose<CurrentGroupProvider, Group?>((ref) {
  return CurrentGroupProvider(
    ref.watch(groupsRepositoryProvider),
  );
});

class CurrentGroupProvider extends StateNotifier<Group?> {
  final GroupsRepository _groupsRepository;

  CurrentGroupProvider(this._groupsRepository) : super(null) {
    _fetchCurrentGroup();
  }

  Future<void> _fetchCurrentGroup() async {
    state = await _groupsRepository.fetchCurrentGroup();
  }

  Future<void> regenerateInvitationCode() async {
    await _groupsRepository.regenerateInvitationCode();
    _fetchCurrentGroup();
  }
}
