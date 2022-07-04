import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:makeup_webapp/ApiCalls/routes.dart';
import 'package:makeup_webapp/Model/Product/product_model/product_model.dart';
import 'package:makeup_webapp/Model/Product/product_model/product_model_response.dart';
import 'package:makeup_webapp/Model/User/UserModel/register_user_model/register_user_model.dart';
import 'package:makeup_webapp/Model/User/UserModelResponse/user_model_response/user_model_response.dart';

// User API
abstract class UserApiCalls {
  Future<UserModelResponse?> createUser(UserModel userModel);
  Future<UserModelResponse?> login(UserModel userModel);
}

// Product API
abstract class ProductApiCalls {
  Future<List<ProductModel>> getAllProducts();
}

//------User DB extension-------//
@override
class UserdDB extends UserApiCalls {
  final dio = Dio();
  final route = Routes();

  UserdDB() {
    dio.options = BaseOptions(
      baseUrl: route.baseUrl,
      responseType: ResponseType.plain,
    );
  }

  //--singleton
  UserdDB._internal();
  static UserdDB instance = UserdDB._internal();
  factory() {
    return instance;
  }
  //---end singleton

//Login
  @override
  Future<UserModelResponse?> login(UserModel userModel) async {
    UserModelResponse? retrievedUser;
    try {
      Response response = await dio.post(
        route.login,
        data: {
          'email': userModel.email,
          'password': userModel.password,
        },
        options: Options(
          contentType: "application/x-www-form-urlencoded",
        ),
      );
      final json = jsonDecode(response.data);
      retrievedUser = UserModelResponse.fromJson(json as Map<String, dynamic>);
    } on DioError catch (e) {
      print('Dio error=== $e');
      return null;
    } catch (e) {
      print('other error == $e');
      return null;
    }
    return retrievedUser;
  }

//Signup
  @override
  Future<UserModelResponse?> createUser(UserModel userModel) async {
    UserModelResponse? retrievedUser;
    try {
      Response response = await dio.post(
        route.signup,
        data: userModel.toJson(),
      );
      final json = jsonDecode(response.data);
      retrievedUser = UserModelResponse.fromJson(json as Map<String, dynamic>);
    } on DioError {
      return null;
    } catch (e) {
      return null;
    }
    return retrievedUser;
  }
}

// Products extension
@override
class ProductDB extends ProductApiCalls {
  final dio = Dio();
  final route = Routes();
  ValueNotifier<List<ProductModel>> productListNotifier = ValueNotifier([]);

  ProductDB() {
    dio.options = BaseOptions(
      baseUrl: route.baseUrl,
      responseType: ResponseType.json,
    );
  }

//--singleton
  ProductDB._internal();
  static ProductDB instance = ProductDB._internal();
  factory() {
    return instance;
  }
//---end singleton

  // get products api
  @override
  Future<List<ProductModel>> getAllProducts() async {
    List<ProductModel> products = [];
    try {
      Response response = await dio.get(
        route.baseUrl + route.getAllProducts,
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            'Authorization':
                "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJwdWJsaWNfaWQiOiJhNWI0ZDI1OS05ODIwLTQ4MzYtOTYwMi1mMGFlNzRkMDZiYjciLCJleHAiOjE2NTY2MzM2NDJ9._dPq3CNSYmsxC0ueoHZ4iLvHp7Orry5wofZkA6abmHI",
          },
        ),
      );
      print(response.data);
      if (response.data == null) {
        return [];
      } else {
        final json = jsonDecode(response.data);
        final productsResponse =
            ProductModelResponse.fromJson(json as Map<String, dynamic>);
        products = productsResponse.result!.data!;
        productListNotifier.value.clear();
        productListNotifier.value.addAll(products);
        return products;
      }
    } on DioError catch (e) {
      print(e);
      productListNotifier.value.clear();
      return [];
    } catch (e) {
      print(e);
      productListNotifier.value.clear();
      return [];
    }
  }
}
