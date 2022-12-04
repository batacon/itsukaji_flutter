import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
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
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('itsukajiへようこそ'),
        centerTitle: true,
      ),
      body: Center(
        child: _isSigningIn
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSignInButton(context),
                  const SizedBox(height: 16),
                  _buildQRCodeScannerButton(context),
                ],
              ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return SignInButton(
      Buttons.Google,
      text: 'Googleでサインイン',
      onPressed: () async {
        try {
          setState(() => _isSigningIn = true);
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
          print(e.toString());
          showSnackBarWithText(context, e.toString());
          // showSnackBarWithText(context, 'ログインに失敗しました。時間をおいて再度お試しください。');
        } finally {
          setState(() => _isSigningIn = false);
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
      ),
      onPressed: () => _openQRCodeScanner(context),
      child: const Text('QRコードで招待してもらう'),
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
            try {
              if (barcode.rawValue == null) return;

              final firebaseUser = (await signInWithGoogle()).user!;
              final invitedGroup = await _groupsRepository.getGroupByInvitationCode(barcode.rawValue!);
              if (invitedGroup == null) {
                if (!mounted) return;
                return showSnackBarWithText(context, '招待コードが無効です');
              }

              final existingUser = await _membersRepository.findMemberById(firebaseUser.uid);
              if (existingUser == null) {
                await _membersRepository.createMember(firebaseUser, invitedGroup.id);
              } else {
                await _membersRepository.updateMemberGroup(existingUser, invitedGroup.id);
              }
              if (!mounted) return;
              showSnackBarWithText(context, '招待コードが無効です');
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const TaskListPage()),
                (_) => false,
              );
            } catch (e) {
              print(e.toString());
              showSnackBarWithText(context, e.toString());
              // showSnackBarWithText(context, 'ログインに失敗しました。時間をおいて再度お試しください。');
              if (FirebaseAuth.instance.currentUser != null) {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().disconnect();
              }
            }
          },
        );
      },
    );
  }
}
