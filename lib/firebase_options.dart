// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBNP69opZ1giwfw3rHBnRCSsT-r-j-duSE',
    appId: '1:103325378423:web:9e61af04c325882dce2372',
    messagingSenderId: '103325378423',
    projectId: 'test-appwithflutter',
    authDomain: 'test-appwithflutter.firebaseapp.com',
    databaseURL: 'https://test-appwithflutter-default-rtdb.firebaseio.com',
    storageBucket: 'test-appwithflutter.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAyWa35qm43xQqUoSQYIJEuQOSKB2MRPi8',
    appId: '1:103325378423:android:f796be157870363bce2372',
    messagingSenderId: '103325378423',
    projectId: 'test-appwithflutter',
    databaseURL: 'https://test-appwithflutter-default-rtdb.firebaseio.com',
    storageBucket: 'test-appwithflutter.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA-3Kq7b1zw9Ofq0O_n4pxV7QTGA0X8r9w',
    appId: '1:103325378423:web:cf347a1888630153ce2372',
    messagingSenderId: '103325378423',
    projectId: 'test-appwithflutter',
    authDomain: 'test-appwithflutter.firebaseapp.com',
    databaseURL: 'https://test-appwithflutter-default-rtdb.firebaseio.com',
    storageBucket: 'test-appwithflutter.appspot.com',
  );

}