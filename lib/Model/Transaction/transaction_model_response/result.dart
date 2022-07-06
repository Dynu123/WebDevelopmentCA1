import 'package:json_annotation/json_annotation.dart';
import 'package:makeup_webapp/Model/Transaction/transaction_model/transaction_model.dart';

part 'result.g.dart';

@JsonSerializable()
class Result {
  String? code;
  List<TransactionModel>? transactionModel;
  String? message;

  Result({this.code, this.transactionModel, this.message});

  factory Result.fromJson(Map<String, dynamic> json) {
    return _$ResultFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
