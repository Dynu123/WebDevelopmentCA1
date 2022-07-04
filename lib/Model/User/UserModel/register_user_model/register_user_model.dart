import 'package:json_annotation/json_annotation.dart';

part 'register_user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "password")
  String? password;

  @JsonKey(name: "phone")
  String? phone;

  @JsonKey(name: "token")
  String? token;

  UserModel({this.name, this.email, this.password, this.phone, this.token});

  UserModel.create({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  //--singleton
  UserModel._internal();
  static UserModel instance = UserModel._internal();
  factory() {
    return instance;
  }
//---end singleton
}
