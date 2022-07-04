import 'package:json_annotation/json_annotation.dart';
import 'package:makeup_webapp/Model/User/UserModel/register_user_model/register_user_model.dart';

part 'result.g.dart';

@JsonSerializable()
class Result {
  String? code;
  UserModel? userModel;
  String? message;

  Result({this.code, this.userModel, this.message});

  factory Result.fromJson(Map<String, dynamic> json) {
    return _$ResultFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
