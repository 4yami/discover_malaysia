// File generated manually for Firebase configuration
// Based on google-services.json from Firebase Console

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
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'macOS platform not configured.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'Windows platform not configured.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Linux platform not configured.',
        );
      default:
        throw UnsupportedError(
          'Unknown platform: $defaultTargetPlatform',
        );
    }
  }

  // Values from Firebase Web config (Firebase Console)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAkKPz1ZakvP_7eAavhpe_30YR6eATdHg8',
    appId: '1:1019123253768:web:49719245de0b84a60907bd',
    messagingSenderId: '1019123253768',
    projectId: 'discover-malaysia',
    authDomain: 'discover-malaysia.firebaseapp.com',
    storageBucket: 'discover-malaysia.firebasestorage.app',
    measurementId: 'G-ZPW3FVLBR6',
  );

  // Values from android/app/google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIJnJv-WbUIngEvSvXd618Rk-d6ieT8TY',
    appId: '1:1019123253768:android:a975d16e3cae74580907bd',
    messagingSenderId: '1019123253768',
    projectId: 'discover-malaysia',
    storageBucket: 'discover-malaysia.firebasestorage.app',
  );

  // Values from ios/Runner/GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjlCSP6wojEqHI8YP_y9bj03addx4eXQI',
    appId: '1:1019123253768:ios:6449e3137472323b0907bd',
    messagingSenderId: '1019123253768',
    projectId: 'discover-malaysia',
    storageBucket: 'discover-malaysia.firebasestorage.app',
    iosBundleId: 'com.example.discoverMalaysia',
  );
}
