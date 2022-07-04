// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModelResponse _$UserModelResponseFromJson(Map<String, dynamic> json) =>
    UserModelResponse(
      result: json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelResponseToJson(UserModelResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
    };
