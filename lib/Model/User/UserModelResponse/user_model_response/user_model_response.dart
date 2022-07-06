import 'package:json_annotation/json_annotation.dart';

import 'result.dart';

part 'user_model_response.g.dart';

@JsonSerializable()
class UserModelResponse {

  //--singleton
  static final UserModelResponse instance = UserModelResponse._internal();
  factory() {
    return instance;
  }

  UserModelResponse._internal();
  //---end singleton

  Result? result;

  UserModelResponse({this.result});

  factory UserModelResponse.fromJson(Map<String, dynamic> json) {
    return _$UserModelResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserModelResponseToJson(this);
}
