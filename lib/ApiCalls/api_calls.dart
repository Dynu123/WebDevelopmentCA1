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

