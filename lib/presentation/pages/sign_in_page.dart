import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
              await signInWithGoogle();
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

// Googleを使ってサインイン
Future<UserCredential> signInWithGoogle() async {
  // 認証フローのトリガー
  final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
  // リクエストから、認証情報を取得
  final googleAuth = await googleUser!.authentication;
  // クレデンシャルを新しく作成
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  // サインインしたら、UserCredentialを返す
  return FirebaseAuth.instance.signInWithCredential(credential);
}
