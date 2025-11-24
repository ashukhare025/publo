// File manually created from your JSON and plist
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Web not provided
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    authDomain: '',
    storageBucket: '',
    measurementId: '',
  );

  // Android values from google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAxRpmSAbKVDYANyk71XvYYDWT4zQ2SqJU',
    appId: '1:660569365420:android:ebf4944d198ac73510f809',
    messagingSenderId: '660569365420',
    projectId: 'publogoo-5ed7c',
    storageBucket: 'publogoo-5ed7c.firebasestorage.app',
  );

  // iOS values from GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5tvIsOJl6LLc3X1iTTPyrPlWbRPPcXdo',
    appId: '',
    messagingSenderId: '',
    projectId: 'publogoo-5ed7c',
    storageBucket: '',
    iosClientId:
    '660569365420-gu0h59d4vst1hv8uvnjp60r81vbj8d2e.apps.googleusercontent.com',
    iosBundleId: 'com.publogoo',
  );
}
