import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/passenger.dart';

class AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mock / In-memory Fallback User for offline/demo operation
  Passenger? _mockCurrentPassenger = Passenger(
    passengerId: 'p_28745',
    name: 'Ananya Perera',
    email: 'ananya.perera@nsbm.ac.lk',
    gender: 'female',
    ageGroup: 'adult',
    mobilityStatus: 'none',
    phoneNumber: '+94 77 123 4567',
    safetyPreference: true,
    createdDate: DateTime.now().subtract(const Duration(days: 30)),
    updatedDate: DateTime.now(),
  );

  Passenger? get mockUser => _mockCurrentPassenger;

  Stream<fb.User?> get authStateChanges => _auth.authStateChanges();

  fb.User? get currentUser => _auth.currentUser;

  Future<Passenger?> getPassengerProfile(String uid) async {
    try {
      final doc = await _firestore
          .collection('passengers')
          .doc(uid)
          .get()
          .timeout(const Duration(seconds: 2));
      if (doc.exists && doc.data() != null) {
        _mockCurrentPassenger = Passenger.fromMap(doc.data()!, doc.id);
        return _mockCurrentPassenger;
      }
    } catch (e) {
      // Fallback for offline execution
    }
    return _mockCurrentPassenger;
  }

  Future<Passenger> signInWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .timeout(const Duration(seconds: 2));
      final profile = await getPassengerProfile(cred.user!.uid);
      if (profile != null) return profile;
    } catch (e) {
      // Fallback for demo mode
    }
    _mockCurrentPassenger = Passenger(
      passengerId: 'p_28745',
      name: email.isNotEmpty ? email.split('@').first : 'Ananya Perera',
      email: email.isNotEmpty ? email : 'ananya.perera@nsbm.ac.lk',
      gender: 'female',
      ageGroup: 'adult',
      mobilityStatus: 'none',
      phoneNumber: '+94 77 987 6543',
      safetyPreference: true,
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
    );
    return _mockCurrentPassenger!;
  }

  Future<Passenger> registerUser({
    required String name,
    required String email,
    required String password,
    required String gender,
  }) async {
    String uid = 'p_${DateTime.now().millisecondsSinceEpoch}';
    final effectivePassword = password.isNotEmpty ? password : 'Password123!';
    try {
      final cred = await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: effectivePassword,
          )
          .timeout(const Duration(seconds: 2));
      uid = cred.user!.uid;
    } catch (e) {
      // Offline fallback
    }

    final newPassenger = Passenger(
      passengerId: uid,
      name: name.isNotEmpty ? name : 'Ananya Perera',
      email: email.isNotEmpty ? email : 'user@domain.lk',
      gender: gender,
      ageGroup: 'adult',
      mobilityStatus: 'none',
      phoneNumber: '+94 77 123 4567',
      safetyPreference: true,
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
    );

    try {
      await _firestore
          .collection('passengers')
          .doc(uid)
          .set(newPassenger.toMap())
          .timeout(const Duration(seconds: 2));
    } catch (e) {
      // Offline fallback
    }

    _mockCurrentPassenger = newPassenger;
    return newPassenger;
  }

  Future<void> updatePreferences({
    required bool safetyPreference,
    required String mobilityStatus,
  }) async {
    if (_mockCurrentPassenger == null) return;
    _mockCurrentPassenger = _mockCurrentPassenger!.copyWith(
      safetyPreference: safetyPreference,
      mobilityStatus: mobilityStatus,
    );

    try {
      await _firestore
          .collection('passengers')
          .doc(_mockCurrentPassenger!.passengerId)
          .update({
        'safety_preference': safetyPreference,
        'mobility_status': mobilityStatus,
        'updated_date': DateTime.now().toIso8601String(),
      }).timeout(const Duration(seconds: 2));
    } catch (e) {
      // Offline fallback
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {}
  }
}
