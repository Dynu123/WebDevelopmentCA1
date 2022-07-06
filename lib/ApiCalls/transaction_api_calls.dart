import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:makeup_webapp/ApiCalls/auth_controller.dart';
import 'package:makeup_webapp/ApiCalls/routes.dart';
import 'package:makeup_webapp/Model/Transaction/transaction_model/transaction_model.dart';
import 'package:makeup_webapp/Model/Transaction/transaction_model_response/transaction_model_response.dart';
import 'package:makeup_webapp/Model/User/UserModel/register_user_model/register_user_model.dart';

abstract class TransactionApiCalls {
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel> getTransactionById();
  Future<void> updateTransactionById();
  Future<void> deleteTransactionById();
  Future<String?> addNewTransaction(TransactionModel transactionModel);
}

class TransactionDB extends TransactionApiCalls {
  final dio = Dio();
  final route = Routes();

  TransactionDB() {
    dio.options = BaseOptions(
      baseUrl: route.baseUrl,
      responseType: ResponseType.plain,
    );
  }

  //--singleton
  TransactionDB._internal();
  static TransactionDB instance = TransactionDB._internal();
  factory() {
    return instance;
  }
  //---end singleton

  @override
  Future<String?> addNewTransaction(TransactionModel transactionModel) async {
    TransactionModelResponse? transactionResponse;
    print("input===${transactionModel.toJson()}");
    try {
      Response response = await dio.post(
        route.addTransaction,
        data: transactionModel.toJson(),
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            'Authorization': LoginUserDB.instance.userModel?.token,
          },
        ),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.data);
        transactionResponse =
            TransactionModelResponse.fromJson(json as Map<String, dynamic>);
        return transactionResponse.result?.message;
      } else {
        return "Some error occured";
      }
    } on DioError catch (e) {
      return e.toString();
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<void> deleteTransactionById() {
    // TODO: implement deleteTransactionById
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() {
    // TODO: implement getAllTransactions
    throw UnimplementedError();
  }

  @override
  Future<TransactionModel> getTransactionById() {
    // TODO: implement getTransactionById
    throw UnimplementedError();
  }

  @override
  Future<void> updateTransactionById() {
    // TODO: implement updateTransactionById
    throw UnimplementedError();
  }
}
