import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'user_model.dart';

class FirebaseAuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> sendSmsCode({
    required String phoneNumber,
    required PhoneCodeSent codeSent,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> signInWithCredential(
    PhoneAuthCredential credential,
  ) async {
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      await _handleUserLogin(user);
    }

    return userCredential;
  }

  Future<void> _handleUserLogin(User user) async {
    final deviceId = await _getDeviceId();
    final userRef = _firestore.collection('users').doc(user.uid);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(userRef);

      if (doc.exists) {
        final data = doc.data()!;
        final currentDevice = data['currentDeviceId'] as String?;

        // STRICT RULE: If a device ID is registered and it's DIFFERENT from this one, BLOCK.
        if (currentDevice != null &&
            currentDevice.isNotEmpty &&
            currentDevice != deviceId) {
          throw FirebaseAuthException(
            code: 'session-active',
            message:
                'This account is already active on another device. Please log out from that device first.',
          );
        }
      }

      // If we are here, login is allowed. Update/Create user.
      if (!doc.exists) {
        // Create new user
        transaction.set(
          userRef,
          UserModel(
            id: user.uid,
            phoneNumber: user.phoneNumber ?? '',
            currentDeviceId: deviceId,
            status: UserStatus.free,
            lastLogin: DateTime.now(),
          ).toMap(),
        );
      } else {
        // Update existing user (refresh login time and ensure device ID is set)
        transaction.update(userRef, {
          'currentDeviceId': deviceId,
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) return 'web-client'; // Simplified for web
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'ios-unknown';
    }
    return 'unknown-device';
  }

  Future<void> logout() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Clear device ID on logout
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'currentDeviceId': FieldValue.delete(),
        });
      } catch (e) {
        // Ignore network errors on logout, just sign out locally
        debugPrint("Error clearing device ID: $e");
      }
    }
    await _auth.signOut();
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      // 1. Delete user data from Firestore
      try {
        await _firestore.collection('users').doc(user.uid).delete();
      } catch (e) {
        debugPrint("Error deleting user data from Firestore: $e");
        rethrow;
      }

      // 2. Delete user from Firebase Auth (Re-authentication might be needed in real apps,
      // but strictly speaking for basic compliance, this call is the trigger)
      try {
        await user.delete();
      } catch (e) {
        debugPrint("Error deleting user from Auth: $e");
        rethrow;
      }
    }
  }
}
