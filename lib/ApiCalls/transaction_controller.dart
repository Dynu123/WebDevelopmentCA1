import 'package:http/http.dart' as http;
import 'package:makeup_webapp/ApiCalls/auth_controller.dart';
import 'package:makeup_webapp/ApiCalls/routes.dart';
import 'dart:convert';

import 'package:makeup_webapp/Model/Transaction/transaction_model/transaction_model.dart';

class TransactionController {
  Future<http.Response?> getAllTransactions() async {
    String url = Routes().baseUrl + Routes().getAllTransactions;
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          "content-type": "application/json",
          'Authorization': "${LoginUserDB.instance.userModel?.token}",
          'Access-Control-Allow-Origin': '*'
        },
      );
      // ignore: avoid_print
      print('URL==== $url');
      // ignore: avoid_print
      print('Http status code==== ${response.statusCode}');
      // ignore: avoid_print
      print('get all transactions response=====${json.decode(response.body)}');
      return response;
    } on Exception catch (e) {
      // ignore: avoid_print
      print('error=====$e');
    }
    return null;
  }

  Future<http.Response?> addTransaction(String title, String amount,
      String type, String? date, String note, int? userId) async {
    String url = Routes().baseUrl + Routes().addTransaction;
    Map data = {
      'title': title,
      'amount': amount,
      'type': type,
      'date': date,
      'note': note,
      'user_id': userId
    };
    try {
      var response = await http.post(
        Uri.parse(url),
        body: json.encode(data),
        headers: {
          "content-type": "application/json",
          'Authorization': "${LoginUserDB.instance.userModel?.token}",
          'Access-Control-Allow-Origin': '*'
        },
      );
      // ignore: avoid_print
      print('URL==== $url');
      // ignore: avoid_print
      print('Http status code==== ${response.statusCode}');
      // ignore: avoid_print
      print('add transaction response=====${json.decode(response.body)}');
      return response;
    } on Exception catch (e) {
      print('error=====$e');
    }
    ;
    return null;
  }

  Future<http.Response?> updateTransaction(TransactionModel transaction) async {
    String url = Routes().baseUrl + Routes().updateTransaction;
    Map data = {
      'transaction_id': transaction.transactionId,
      'title': transaction.title,
      'amount': transaction.amount,
      'type': transaction.type,
      'date': transaction.date,
      'note': transaction.note,
      'user_id': transaction.userId
    };
    try {
      var response = await http.put(
        Uri.parse(url),
        body: json.encode(data),
        headers: {
          "content-type": "application/json",
          'Authorization': "${LoginUserDB.instance.userModel?.token}",
          'Access-Control-Allow-Origin': '*'
        },
      );
      // ignore: avoid_print
      print('URL==== $url');
      // ignore: avoid_print
      print('Http status code==== ${response.statusCode}');
      // ignore: avoid_print
      print('edit transaction response=====${json.decode(response.body)}');
      return response;
    } on Exception catch (e) {
      print('error=====$e');
    }
    ;
    return null;
  }

  Future<http.Response?> deleteTransaction(TransactionModel transaction) async {
    String url =
        "${Routes().baseUrl}${Routes().deleteTransactionById}/${transaction.transactionId}";
    // ignore: avoid_print
    print('URL==== $url');
    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': "${LoginUserDB.instance.userModel?.token}",
          'Access-Control-Allow-Origin': '*'
        },
      );

      // ignore: avoid_print
      print('Http status code==== ${response.statusCode}');
      // ignore: avoid_print
      print('deleted transaction response=====${json.decode(response.body)}');
      return response;
    } on Exception catch (e) {
      print('error=====$e');
    }
    ;
    return null;
  }
}
