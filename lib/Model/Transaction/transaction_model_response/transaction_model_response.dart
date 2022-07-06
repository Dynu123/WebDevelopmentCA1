import 'package:json_annotation/json_annotation.dart';

import 'result.dart';

part 'transaction_model_response.g.dart';

@JsonSerializable()
class TransactionModelResponse {
  Result? result;

  TransactionModelResponse({this.result});

  factory TransactionModelResponse.fromJson(Map<String, dynamic> json) {
    return _$TransactionModelResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TransactionModelResponseToJson(this);
}
