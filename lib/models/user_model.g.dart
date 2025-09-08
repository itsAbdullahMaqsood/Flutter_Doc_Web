// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  uid: json['_id'] as String,
  profilePic: json['profilePic'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  token: json['token'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'token': instance.token,
  'profilePic': instance.profilePic,
  'name': instance.name,
  'email': instance.email,
  'uid': instance.uid,
};
