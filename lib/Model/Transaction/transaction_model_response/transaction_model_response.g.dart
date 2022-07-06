// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModelResponse _$TransactionModelResponseFromJson(
        Map<String, dynamic> json) =>
    TransactionModelResponse(
      result: json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionModelResponseToJson(
        TransactionModelResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
    };
