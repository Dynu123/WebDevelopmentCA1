import 'package:json_annotation/json_annotation.dart';

import 'result.dart';

part 'product_model_response.g.dart';

@JsonSerializable()
class ProductModelResponse {
  Result? result;

  ProductModelResponse({this.result});

  factory ProductModelResponse.fromJson(Map<String, dynamic> json) {
    return _$ProductModelResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductModelResponseToJson(this);
}
