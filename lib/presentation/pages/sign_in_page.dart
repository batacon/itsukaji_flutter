import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:itsukaji_flutter/common/show_snack_bar_with_text.dart';
import 'package:itsukaji_flutter/presentation/pages/task_list_page.dart';
import 'package:itsukaji_flutter/repositories/groups_repository.dart';
import 'package:itsukaji_flutter/repositories/members_repository.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _groupsRepository = GroupsRepository();
  final _membersRepository = MembersRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSignInButton(context),
            _buildQRCodeScannerButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('Googleでログイン'),
      onPressed: () async {
        try {
          final firebaseUser = (await signInWithGoogle()).user!;
          final foundUser = await _membersRepository.findMemberById(firebaseUser.uid);
          if (foundUser == null) {
            final newGroup = await _groupsRepository.createGroup();
            await _membersRepository.createMember(firebaseUser, newGroup.id);
          }
          if (!mounted) return;

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const TaskListPage()),
          );
        } on Exception catch (e) {
          print('${e.toString()}');
          showSnackBarWithText(context, 'ログインに失敗しました。時間をおいて再度お試しください。');
        }
      },
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
    final googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Widget _buildQRCodeScannerButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('QRコードで招待してもらう'),
      onPressed: () => _openQRCodeScanner(context),
    );
  }

  _openQRCodeScanner(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MobileScanner(
          allowDuplicates: false,
          controller: MobileScannerController(facing: CameraFacing.back, torchEnabled: false),
          onDetect: (barcode, args) async {
            if (barcode.rawValue == null) return;

            final invitedGroup = await _groupsRepository.getGroupByInvitationCode(barcode.rawValue!);
            if (invitedGroup == null) {
              if (!mounted) return;
              return showSnackBarWithText(context, '招待コードが無効です');
            }

            final firebaseUser = (await signInWithGoogle()).user!;
            final existingUser = await _membersRepository.findMemberById(firebaseUser.uid);
            if (existingUser == null) {
              await _membersRepository.createMember(firebaseUser, invitedGroup.id);
            } else {
              await _membersRepository.updateMemberGroup(existingUser, invitedGroup.id);
            }
            if (!mounted) return;

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const TaskListPage()),
            );
          },
        );
      },
    );
  }
}
