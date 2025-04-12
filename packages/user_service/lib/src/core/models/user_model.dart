import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String? uuid,
    required String email,
    required String fullName,
    required String? photoUrl,
    required String? phoneNumber,
    required int? birthYear,
  }) = _User;

  factory User.empty() {
    return const User(
      uuid: '',
      email: '',
      fullName: '',
      photoUrl: '',
      phoneNumber: '',
      birthYear: null,
    );
  }

  factory User.guest() {
    return const User(
      uuid: '',
      email: '',
      fullName: 'Guest',
      photoUrl: '',
      phoneNumber: '',
      birthYear: null,
    );
  }

  factory User.toUser(auth.User user) {
    return User(
      uuid: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? '',
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
      birthYear: null,
    );
  }

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return User(
      uuid: snapshot.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      photoUrl: data['photoUrl'],
      phoneNumber: data['phoneNumber'],
      birthYear: data['birthYear'],
    );
  }
}

extension UserExtensions on User {
  Map<String, dynamic> toDocument() {
    return {
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'birthYear': birthYear,
    };
  }
}
