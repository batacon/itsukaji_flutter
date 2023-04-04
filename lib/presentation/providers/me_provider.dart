import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itsukaji_flutter/models/member.dart';
import 'package:itsukaji_flutter/repositories/members_repository.dart';

final meProvider = StateNotifierProvider.autoDispose<MeProvider, Member>((ref) {
  return MeProvider(
    ref.watch(membersRepositoryProvider),
  );
});

class MeProvider extends StateNotifier<Member?> {
  final MembersRepository _membersRepository;

  MeProvider(this._membersRepository) : super(null) {
    _init();
  }

  Future<void> _init() async {
    state = await _membersRepository.getCurrentMember();
  }
}
