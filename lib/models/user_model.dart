import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  const UserModel({
    required this.uid,
    required this.profilePic,
    required this.name,
    required this.email,
    required this.token,
  });
  final String? token;
  final String profilePic;
  final String name;
  final String email;
  final String uid;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? uid,
    String? profilePic,
    String? name,
    String? email,
    String? token,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
}
