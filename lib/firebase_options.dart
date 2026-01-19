import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDUDgJ1KYYd0xbAfK91VDSGqSe5WUoJvj8',
    appId: '1:888391480240:web:2cf924108a57bfbb969c75',
    messagingSenderId: '888391480240',
    projectId: 'heria-ai-app-br',
    authDomain: 'heria-ai-app-br.firebaseapp.com',
    storageBucket: 'heria-ai-app-br.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqdrgVTi1o1XNsI1ksLpZs_WX1OMISBhk',
    appId: '1:888391480240:android:f556576542f156e8969c75',
    messagingSenderId: '888391480240',
    projectId: 'heria-ai-app-br',
    storageBucket: 'heria-ai-app-br.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBC5X7bNZLXWrAclCQiZxLquUnnJd7DKfw',
    appId: '1:888391480240:ios:43d1c70b71480009969c75',
    messagingSenderId: '888391480240',
    projectId: 'heria-ai-app-br',
    storageBucket: 'heria-ai-app-br.firebasestorage.app',
    iosBundleId: 'com.example.heriaAiApp',
  );
}
