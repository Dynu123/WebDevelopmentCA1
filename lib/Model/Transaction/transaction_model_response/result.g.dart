// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      code: json['code'] as String?,
      transactionModel: (json['data'] as List<dynamic>?)
          ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'code': instance.code,
      'data': instance.transactionModel,
      'message': instance.message,
    };
