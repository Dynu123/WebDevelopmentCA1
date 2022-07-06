import 'package:flutter/material.dart';
import 'package:makeup_webapp/ApiCalls/transaction_controller.dart';
import 'package:makeup_webapp/Model/Transaction/transaction_model/transaction_model.dart';
import 'package:makeup_webapp/Screens/screen_add_transaction.dart';
import 'package:makeup_webapp/Screens/screen_expense_details.dart';
import 'package:makeup_webapp/Screens/screen_login.dart';
import 'dart:convert';

enum TransactionType {
  expense,
  income,
}

class ScreenListExpense extends StatefulWidget {
  const ScreenListExpense({Key? key}) : super(key: key);

  @override
  State<ScreenListExpense> createState() => _ScreenListExpenseState();
}

class _ScreenListExpenseState extends State<ScreenListExpense> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<TransactionModel> transactions = [];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //call get transaction list api
      await getAllTransactions();
    });
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text("All transactions"),
                const SizedBox(),
                IconButton(
                  onPressed: () {
                    //add transaction
                    goToAddTransactionPage(context, ActionType.add, null);
                  },
                  icon: const Icon(Icons.add_box),
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.currency_bitcoin, size: 45),
                          title: Text(transactions[index].title ?? ""),
                          subtitle: Text(transactions[index].type ?? ""),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  //edit item
                                  goToAddTransactionPage(
                                    context,
                                    ActionType.edit,
                                    transactions[index],
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  //delete item
                                  deleteTransaction(transactions[index]);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                              IconButton(
                                  onPressed: () {
                                    //go to detail page
                                    goToDetailPage(
                                        context, transactions[index]);
                                  },
                                  icon: const Icon(Icons.arrow_forward)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const Divider(
                    thickness: 0,
                  );
                },
                itemCount: transactions.length)));
  }

  signout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx1) => const ScreenLogin()),
        (route) => false);
  }

  Future<void> getAllTransactions() async {
    TransactionController transController = TransactionController();

    var response = await transController.getAllTransactions();

    var allTransResp = json.decode(response!.body);

    if (response.statusCode == 200) {
      if (allTransResp['result']['code'] == 200) {
        final transactionList = allTransResp['result']['data'];
        setState(() {
          transactions.clear();
        });

        for (var transaction in transactionList) {
          var eachTransaction = TransactionModel.fromJson(transaction);
          setState(() {
            transactions.add(eachTransaction);
          });
        }
      } else {
        var message = allTransResp['result']['message'];
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } else if (response.statusCode == 400) {
      var message = allTransResp['result']['message'];
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(message)));
    } else {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(response.body.toString())));
    }
  }

  goToDetailPage(BuildContext context, TransactionModel transaction) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => ScreenExpenseDetail(transaction: transaction)));
  }

  goToAddTransactionPage(
      BuildContext context, ActionType action, TransactionModel? transaction) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => ScreenAddTransaction(
        action: action,
        transaction: transaction,
      ),
    ));
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    TransactionController transController = TransactionController();

    var response = await transController.deleteTransaction(transaction);
    var deletedTransResp = json.decode(response!.body);

    if (response.statusCode == 200) {
      var message = deletedTransResp['result']['message'];
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(message)));
    } else if (response.statusCode == 400) {
      var message = deletedTransResp['result']['message'];
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(message)));
    } else {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(response.body.toString())));
    }
  }
}
