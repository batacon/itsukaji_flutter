import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:itsukaji_flutter/common/custom_color.dart';
import 'package:itsukaji_flutter/common/show_snack_bar_with_text.dart';
import 'package:itsukaji_flutter/presentation/pages/main_page.dart';
import 'package:itsukaji_flutter/repositories/groups_repository.dart';
import 'package:itsukaji_flutter/repositories/members_repository.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({final Key? key}) : super(key: key);

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _membersRepository = MembersRepository();
  bool _isSigningIn = false;

  @override
  Widget build(final BuildContext context) {
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

  Widget _buildSignInButton(final BuildContext context) {
    return SignInButton(
      Buttons.Google,
      text: 'Googleでサインイン',
      onPressed: () async {
        try {
          setState(() => _isSigningIn = true);
          final firebaseUser = (await signInWithGoogle()).user!;
          final foundUser = await _membersRepository.findMemberById(firebaseUser.uid);
          if (foundUser == null) {
            final newGroup = await ref.watch(groupsRepositoryProvider).createGroup();
            await _membersRepository.createMember(firebaseUser, newGroup.id);
          }
          if (!mounted) return;

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (final context) => const MainPage()),
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

  Widget _buildQRCodeScannerButton(final BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: CustomColor.primary,
      ),
      onPressed: () => _openQRCodeScanner(context),
      child: const Text('QRコードで招待してもらう'),
    );
  }

  _openQRCodeScanner(final BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (final context) {
        return MobileScanner(
          controller: MobileScannerController(facing: CameraFacing.back, torchEnabled: false),
          onDetect: (final barcode) async {
            try {
              if (barcode.raw == null) return;

              final firebaseUser = (await signInWithGoogle()).user!;
              final invitedGroup = await ref.watch(groupsRepositoryProvider).getGroupByInvitationCode(barcode.raw!);
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
                MaterialPageRoute(builder: (final context) => const MainPage()),
                (final _) => false,
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
