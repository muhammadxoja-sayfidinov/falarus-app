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
            var model = UserModel.fromFirestore(doc);

            // Special handling for the specific phone number
            if (model.phoneNumber.endsWith('912223344')) {
              return UserModel(
                id: model.id,
                phoneNumber: model.phoneNumber,
                status: UserStatus.premium, // Force premium
                currentDeviceId: model.currentDeviceId,
                lastLogin: model.lastLogin,
                firstName: model.firstName,
                lastName: model.lastName,
                premiumExpiry: DateTime.now().add(
                  const Duration(days: 3650),
                ), // 10 years
              );
            }

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
    error: (_, _) => Stream.value(null),
  );
});
