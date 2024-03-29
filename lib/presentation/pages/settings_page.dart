import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:itsukaji_flutter/presentation/components/nickname_form_field.dart';
import 'package:itsukaji_flutter/presentation/pages/sign_in_page.dart';
import 'package:itsukaji_flutter/repositories/groups_repository.dart';
import 'package:itsukaji_flutter/repositories/members_repository.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const NicknameFormField(),
              const SizedBox(height: 20),
              _buildSignOutButton(context),
              const SizedBox(height: 540),
              _buildDeleteAccountButton(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(final BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        _signOut(context);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('ログアウトする'),
    );
  }

  Widget _buildDeleteAccountButton(final BuildContext context, final WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (final context) {
            return AlertDialog(
              title: const Text('アカウントを削除しますか？'),
              content: const Text('この操作は取り消せません。'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('キャンセル'),
                ),
                TextButton(
                  onPressed: () async {
                    await _deleteAccount(ref);
                    _signOut(context);
                  },
                  child: const Text('本当に削除'),
                ),
              ],
            );
          },
        );
      },
      child: const Text('アカウントを削除する', style: TextStyle(fontWeight: FontWeight.w700)),
    );
  }

  Future<void> _signOut(final BuildContext context) async {
    _backToSignInPage(context);
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();
  }

  Future<void> _deleteAccount(final WidgetRef ref) async {
    final groupsRepository = ref.watch(groupsRepositoryProvider);
    final membersRepository = MembersRepository();
    final currentUser = FirebaseAuth.instance.currentUser!;
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final OAuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await currentUser.reauthenticateWithCredential(googleCredential);
    final group = await groupsRepository.fetchCurrentGroup();
    final groupMembers = await membersRepository.getMembersOf(group.id);
    if (groupMembers.length == 1) {
      await groupsRepository.deleteCurrentGroup();
    }
    await membersRepository.removeMember(currentUser.uid);
    await currentUser.delete();
  }

  void _backToSignInPage(final BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (final context) => const SignInPage()),
      (final _) => false,
    );
  }
}
