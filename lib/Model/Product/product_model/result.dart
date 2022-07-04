import 'package:json_annotation/json_annotation.dart';
import 'package:makeup_webapp/Model/Product/product_model/product_model.dart';

import 'product_model.dart';

part 'result.g.dart';

@JsonSerializable()
class Result {
  int? code;
  List<ProductModel>? data;
  String? message;

  Result({this.code, this.data, this.message});

  factory Result.fromJson(Map<String, dynamic> json) {
    return _$ResultFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
