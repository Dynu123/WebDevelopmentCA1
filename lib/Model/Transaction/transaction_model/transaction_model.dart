import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  String? title;
  String? amount;
  String? type;
  String? date;
  String? note;
  @JsonKey(name: 'user_id')
  int? userId;
  @JsonKey(name: 'transaction_id')
  int? transactionId;

  TransactionModel({
    this.title,
    this.amount,
    this.type,
    this.date,
    this.note,
    this.userId,
  });

   TransactionModel.create({
    required this.title,
    required this.amount,
    required this.type,
    this.date,
    this.note,
    this.userId
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return _$TransactionModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
