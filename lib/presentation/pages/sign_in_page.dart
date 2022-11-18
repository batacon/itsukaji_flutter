import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:itsukaji_flutter/common/firebase_firestore.dart';
import 'package:itsukaji_flutter/models/invitation_code.dart';
import 'package:itsukaji_flutter/presentation/pages/task_list_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final firebaseUser = (await signInWithGoogle()).user!;

              final result = await db.collection('users').where('id', isEqualTo: firebaseUser.uid).get();
              final userDocuments = result.docs;
              if (userDocuments.isEmpty) {
                final newGroup = await db.collection('groups').add({
                  'users': [firebaseUser.uid],
                  'invitation_code': InvitationCode.generate(),
                });

                db.collection('users').add({
                  'id': firebaseUser.uid,
                  'name': firebaseUser.displayName,
                  'group_id': newGroup.id,
                });
              }
              if (!mounted) return;

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const TaskListPage()),
              );
            } on Exception catch (e) {
              print('${e.toString()}');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.black,
                  content: Text(
                    'ログインに失敗しました。時間をおいて再度お試しください。',
                    style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
                  ),
                ),
              );
            }
          },
          child: const Text('Sign In'),
        ),
      ),
    );
  }
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
