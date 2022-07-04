import 'package:json_annotation/json_annotation.dart';

part 'product_color.g.dart';

@JsonSerializable()
class ProductColor {
  @JsonKey(name: 'colour_name')
  String? colourName;
  @JsonKey(name: 'hex_value')
  String? hexValue;

  ProductColor({this.colourName, this.hexValue});

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return _$ProductColorFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductColorToJson(this);
}
