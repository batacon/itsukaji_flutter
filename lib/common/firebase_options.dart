// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB7gHWpRXaqd2nicQbNhqxNu36I6anLnns',
    appId: '1:909184335641:web:ce85aa04a8a1c4dffc8f88',
    messagingSenderId: '909184335641',
    projectId: 'itsukaji-fe630',
    authDomain: 'itsukaji-fe630.firebaseapp.com',
    storageBucket: 'itsukaji-fe630.appspot.com',
    measurementId: 'G-9E8GFT2WG9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBeeDXAWKZJAZ328q6LasquwhcZ8e4EbZc',
    appId: '1:909184335641:android:9b379a84e27197a2fc8f88',
    messagingSenderId: '909184335641',
    projectId: 'itsukaji-fe630',
    storageBucket: 'itsukaji-fe630.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCj1v2Uvnx6yiCnadZzuLzfWSDx1A29Uro',
    appId: '1:909184335641:ios:c4957204a09a42aefc8f88',
    messagingSenderId: '909184335641',
    projectId: 'itsukaji-fe630',
    storageBucket: 'itsukaji-fe630.appspot.com',
    iosClientId: '909184335641-i0oijbas96u1neeo05q3ip7shkdqonni.apps.googleusercontent.com',
    iosBundleId: 'com.example.itsukajiFlutter',
  );
}