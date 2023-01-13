import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:itsukaji_flutter/models/group.dart';
import 'package:itsukaji_flutter/presentation/pages/sign_in_page.dart';
import 'package:itsukaji_flutter/repositories/groups_repository.dart';
import 'package:itsukaji_flutter/repositories/members_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _groupsRepository = GroupsRepository();
  final _membersRepository = MembersRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('グループ設定'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FutureBuilder(
              future: _groupsRepository.getCurrentGroup(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final group = snapshot.data as Group;
                  return Center(
                    child: Column(
                      children: [
                        const Text('グループコード'),
                        QrImage(
                          data: group.invitationCode,
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                        _buildDeleteAccountButton(context),
                      ],
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            _buildSignOutButton(context),
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildSignOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        _signOut(context);
      },
      child: const Text('Sign Out'),
    );
  }

  ElevatedButton _buildDeleteAccountButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) {
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
                    await _deleteAccount();
                    _signOut(context);
                  },
                  child: const Text('本当に削除'),
                ),
              ],
            );
          },
        );
      },
      child: const Text('Delete Account'),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    _backToSignInPage(context);
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();
  }

  Future<void> _deleteAccount() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final OAuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await currentUser.reauthenticateWithCredential(googleCredential);
    final group = await _groupsRepository.getCurrentGroup();
    final groupMembers = await _membersRepository.getMembersOf(group.id);
    if (groupMembers.length == 1) {
      await _groupsRepository.deleteCurrentGroup();
    }
    await _membersRepository.removeMember(currentUser.uid);
    await currentUser.delete();
  }

  void _backToSignInPage(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SignInPage()),
      (_) => false,
    );
  }
}
