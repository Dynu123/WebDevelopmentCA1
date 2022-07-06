// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      title: json['title'] as String?,
      amount: json['amount'] as String?,
      type: json['type'] as String?,
      date: json['date'] as String?,
      note: json['note'] as String?,
      userId: json['user_id'] as int?,
    )..transactionId = json['transaction_id'] as int?;

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'amount': instance.amount,
      'type': instance.type,
      'date': instance.date,
      'note': instance.note,
      'user_id': instance.userId,
      'transaction_id': instance.transactionId,
    };
