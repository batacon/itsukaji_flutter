import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:itsukaji_flutter/common/firebase_options.dart';
import 'package:itsukaji_flutter/presentation/pages/sign_in_page.dart';
import 'package:itsukaji_flutter/presentation/pages/task_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: 'itsukaji',
      theme: ThemeData(
        // TODO: オリジナルのカラーパレットを使う
        primarySwatch: Colors.blue,
      ),
      home: FirebaseAuth.instance.currentUser == null ? const SignInPage() : const TaskListPage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja', 'JP')],
    );
  }
}
