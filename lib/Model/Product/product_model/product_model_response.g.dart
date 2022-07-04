// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModelResponse _$ProductModelResponseFromJson(
        Map<String, dynamic> json) =>
    ProductModelResponse(
      result: json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductModelResponseToJson(
        ProductModelResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
    };
