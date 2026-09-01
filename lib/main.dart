import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'demo-api-key-safeboard',
          appId: '1:1234567890:web:safeboard',
          messagingSenderId: '1234567890',
          projectId: 'safeboard-28745',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    // Allows robust offline execution & testing without GCP credentials initialized
    debugPrint('Firebase init fallback: $e');
  }
  runApp(const SafeBoardApp());
}

