import 'package:equatable/equatable.dart';

/// Authenticated user profile stored in Firestore.
class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  final String uid;
  final String name;
  final String email;
  final String? photoUrl;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => [uid, name, email, photoUrl];
}
