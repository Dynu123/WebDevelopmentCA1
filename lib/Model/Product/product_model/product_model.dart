import 'package:json_annotation/json_annotation.dart';

import 'product_color.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  @JsonKey(name: 'api_featured_image')
  String? apiFeaturedImage;
  String? brand;
  String? category;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  String? currency;
  String? description;
  int? id;
  @JsonKey(name: 'image_link')
  String? imageLink;
  String? name;
  String? price;
  @JsonKey(name: 'price_sign')
  String? priceSign;
  @JsonKey(name: 'product_api_url')
  String? productApiUrl;
  @JsonKey(name: 'product_colors')
  List<ProductColor>? productColors;
  @JsonKey(name: 'product_link')
  String? productLink;
  @JsonKey(name: 'product_type')
  String? productType;
  dynamic rating;
  @JsonKey(name: 'tag_list')
  List<String>? tagList;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  @JsonKey(name: 'website_link')
  String? websiteLink;

  ProductModel({
    this.apiFeaturedImage,
    this.brand,
    this.category,
    this.createdAt,
    this.currency,
    this.description,
    this.id,
    this.imageLink,
    this.name,
    this.price,
    this.priceSign,
    this.productApiUrl,
    this.productColors,
    this.productLink,
    this.productType,
    this.rating,
    this.tagList,
    this.updatedAt,
    this.websiteLink,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return _$ProductModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
