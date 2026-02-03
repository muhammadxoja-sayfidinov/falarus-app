import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_model.dart';
import 'firebase_auth_repository.dart';

final authRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final userDocProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((doc) {
            final model = UserModel.fromFirestore(doc);
            if (model.status == UserStatus.premium &&
                model.premiumExpiry != null &&
                model.premiumExpiry!.isBefore(DateTime.now())) {
              // Auto-expire premium status
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({'status': UserStatus.free.name});
            }
            return model;
          });
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});
