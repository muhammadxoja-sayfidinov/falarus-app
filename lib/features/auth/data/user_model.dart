import 'package:cloud_firestore/cloud_firestore.dart';

enum UserStatus { free, premium }

class UserModel {
  final String id;
  final String phoneNumber;
  final UserStatus status;
  final String? currentDeviceId;
  final DateTime? lastLogin;
  final String? firstName;
  final String? lastName;
  final DateTime? premiumExpiry;

  const UserModel({
    required this.id,
    required this.phoneNumber,
    this.status = UserStatus.free,
    this.currentDeviceId,
    this.lastLogin,
    this.firstName,
    this.lastName,
    this.premiumExpiry,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      // Return a default object if data is missing, or throw
      return UserModel(id: doc.id, phoneNumber: '');
    }
    return UserModel(
      id: doc.id,
      phoneNumber: data['phoneNumber'] ?? '',
      status: UserStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => UserStatus.free,
      ),
      currentDeviceId: data['currentDeviceId'],
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
      firstName: data['firstName'],
      lastName: data['lastName'],
      premiumExpiry: (data['premiumExpiry'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'status': status.name,
      'currentDeviceId': currentDeviceId,
      'lastLogin': lastLogin != null
          ? Timestamp.fromDate(lastLogin!)
          : FieldValue.serverTimestamp(),
      'firstName': firstName,
      'lastName': lastName,
      'premiumExpiry': premiumExpiry != null
          ? Timestamp.fromDate(premiumExpiry!)
          : null,
    };
  }
}
