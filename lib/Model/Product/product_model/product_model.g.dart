// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      apiFeaturedImage: json['api_featured_image'] as String?,
      brand: json['brand'] as String?,
      category: json['category'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      currency: json['currency'] as String?,
      description: json['description'] as String?,
      id: json['id'] as int?,
      imageLink: json['image_link'] as String?,
      name: json['name'] as String?,
      price: json['price'] as String?,
      priceSign: json['price_sign'] as String?,
      productApiUrl: json['product_api_url'] as String?,
      productColors: (json['product_colors'] as List<dynamic>?)
          ?.map((e) => ProductColor.fromJson(e as Map<String, dynamic>))
          .toList(),
      productLink: json['product_link'] as String?,
      productType: json['product_type'] as String?,
      rating: json['rating'],
      tagList: (json['tag_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      websiteLink: json['website_link'] as String?,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'api_featured_image': instance.apiFeaturedImage,
      'brand': instance.brand,
      'category': instance.category,
      'created_at': instance.createdAt?.toIso8601String(),
      'currency': instance.currency,
      'description': instance.description,
      'id': instance.id,
      'image_link': instance.imageLink,
      'name': instance.name,
      'price': instance.price,
      'price_sign': instance.priceSign,
      'product_api_url': instance.productApiUrl,
      'product_colors': instance.productColors,
      'product_link': instance.productLink,
      'product_type': instance.productType,
      'rating': instance.rating,
      'tag_list': instance.tagList,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'website_link': instance.websiteLink,
    };
