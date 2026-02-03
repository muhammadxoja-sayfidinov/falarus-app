import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/firebase_auth_repository.dart';

// Simple state for Auth
enum AuthStatus { initial, loading, codeSent, authenticated, error }

class AuthState {
  final AuthStatus status;
  final String? error;
  final String? phoneNumber;
  final String? verificationId;
  final PhoneAuthCredential? autoCredential;

  AuthState({
    this.status = AuthStatus.initial,
    this.error,
    this.phoneNumber,
    this.verificationId,
    this.autoCredential,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? error,
    String? phoneNumber,
    String? verificationId,
    PhoneAuthCredential? autoCredential,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error ?? this.error,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationId: verificationId ?? this.verificationId,
      autoCredential: autoCredential ?? this.autoCredential,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  late final FirebaseAuthRepository _repository;

  @override
  AuthState build() {
    _repository = FirebaseAuthRepository();

    // Listen to real auth state changes
    _repository.authStateChanges.listen((User? user) {
      if (user != null) {
        state = state.copyWith(status: AuthStatus.authenticated);
      }
    });

    return AuthState();
  }

  Future<void> sendSms(String phone) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      await _repository.sendSmsCode(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolution (Android mostly)
          await _repository.signInWithCredential(credential);
          state = state.copyWith(
            status: AuthStatus.authenticated,
            phoneNumber: phone,
            autoCredential: credential,
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          state = state.copyWith(status: AuthStatus.error, error: e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          state = state.copyWith(
            status: AuthStatus.codeSent,
            phoneNumber: phone,
            verificationId: verificationId,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          state = state.copyWith(verificationId: verificationId);
        },
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  Future<bool> verifyCode(String code) async {
    if (state.verificationId == null) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: "Verification ID missing",
      );
      return false;
    }

    state = state.copyWith(status: AuthStatus.loading);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: state.verificationId!,
        smsCode: code,
      );
      await _repository.signInWithCredential(credential);
      state = state.copyWith(status: AuthStatus.authenticated);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: "Invalid Code or Error",
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState();
  }
}

final authProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
