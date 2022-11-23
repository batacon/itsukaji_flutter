import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:itsukaji_flutter/models/group.dart';
import 'package:itsukaji_flutter/presentation/pages/sign_in_page.dart';
import 'package:itsukaji_flutter/repositories/groups_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _groupsRepository = GroupsRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('グループ設定'),
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
                      ],
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                  (_) => false,
                );
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().disconnect();
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
