import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:makeup_webapp/ApiCalls/auth_controller.dart';
import 'package:makeup_webapp/ApiCalls/transaction_controller.dart';
import 'package:makeup_webapp/Model/Transaction/transaction_model/transaction_model.dart';
import 'package:makeup_webapp/Screens/screen_add_transaction.dart';
import 'package:makeup_webapp/Screens/screen_expense_details.dart';
import 'package:makeup_webapp/Screens/screen_login.dart';
import 'dart:convert';

import 'package:makeup_webapp/Screens/screen_myprofile.dart';

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
  bool isLoading = false;
  List<TransactionModel> transactions = [];

  @protected
  @mustCallSuper
  @override
  void initState() {
    //list api
    getTransactionList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.black),
            ),
          )
        : Scaffold(
            key: _scaffoldKey,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              child: const Icon(Icons.add),
              onPressed: () {
                goToAddTransactionPage(context, ActionType.add, null);
              },
            ),
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Welcome, ${LoginUserDB.instance.userModel?.name}!"),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            //show all
                            getTransactionList();
                          },
                          child: const Text(
                            "All",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            //show all incomes
                            getTransactionsByType(TransactionType.income);
                          },
                          child: const Text(
                            "Income",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            //show all expenses
                            getTransactionsByType(TransactionType.expense);
                          },
                          child: const Text(
                            "Expense",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            //go to profile page
                            goToProfilePage(context);
                          },
                          child: const Text(
                            "My profile",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            //signout
                            signout(context);
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
                child: ListView.separated(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.currency_exchange,
                            size: 30,
                            color: Color.fromARGB(255, 4, 134, 71),
                          ),
                          title: Text(
                            transactions[index].title ?? "",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 4, 134, 71),
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                            ),
                          ),
                          subtitle: Text(
                            transactions[index].type ?? "",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "€${transactions[index].amount}",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 4, 134, 71),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    transactions[index].date ?? "",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  //edit item
                                  goToAddTransactionPage(
                                    context,
                                    ActionType.edit,
                                    transactions[index],
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 4, 134, 71),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  //delete item
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Are you sure you want to delete?",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 17),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 4, 134, 71),
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteTransaction(
                                                    transactions[index]);
                                                Navigator.of(ctx).pop();
                                              },
                                              child: const Text(
                                                "OK",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color(0xB7D8382D),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    //go to detail page
                                    showDetailPopup(
                                        context, transactions[index]);
                                    //goToDetailPage(context, transactions[index]);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                    //color: Color.fromARGB(255, 4, 134, 71),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const Divider(
                  thickness: 0,
                );
              },
              itemCount: transactions.length,
            )));
  }

  signout(BuildContext context) {
    LoginUserDB.instance.userModel?.token = null;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx1) => const ScreenLogin()),
        (route) => false);
  }

  getTransactionList() async {
    await getAllTransactions();
  }

  Future<void> getAllTransactions() async {
    TransactionController transController = TransactionController();
    setState(() {
      isLoading = !isLoading;
    });
    var response = await transController.getAllTransactions();
    setState(() {
      isLoading = !isLoading;
    });
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
    } else if (response.statusCode == 401) {
      var message = allTransResp['msg'];
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(message)));
    } else {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(response.body.toString())));
    }
  }

  goToProfilePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const ScreenProfile(),
      ),
    );
  }

  Future<void> getTransactionsByType(TransactionType type) async {
    TransactionController transController = TransactionController();
    setState(() {
      isLoading = !isLoading;
    });
    var response = await transController.getTransactionsByType(type);
    setState(() {
      isLoading = !isLoading;
    });
    var allTransByTypeResp = json.decode(response!.body);

    if (response.statusCode == 200) {
      if (allTransByTypeResp['result']['code'] == 200) {
        final transactionList = allTransByTypeResp['result']['data'];
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
        var message = allTransByTypeResp['result']['message'];
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } else if (response.statusCode == 400) {
      var message = allTransByTypeResp['result']['message'];
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(message)));
    } else if (response.statusCode == 401) {
      var message = allTransByTypeResp['msg'];
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(message)));
    } else {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(response.body.toString())));
    }
  }

  goToAddTransactionPage(
      BuildContext context, ActionType action, TransactionModel? transaction) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            content: Builder(
              builder: (context) {
                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                var height = MediaQuery.of(context).size.height;
                var width = MediaQuery.of(context).size.width;

                return SizedBox(
                  width: width - 800,
                  height: height,
                  child: ScreenAddTransaction(
                    action: action,
                    transaction: transaction,
                  ),
                );
              },
            ),
          );
        }).then((_) => setState(() {
          getAllTransactions();
        }));

    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (ctx) => ScreenAddTransaction(
    //     action: action,
    //     transaction: transaction,
    //   ),
    // ));
  }

  showDetailPopup(BuildContext context, TransactionModel transaction) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            content: Builder(builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;

              return SizedBox(
                width: 400,
                height: 300,
                child: ScreenExpenseDetail(transaction: transaction),
              );
            }),
          );
        });
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    TransactionController transController = TransactionController();
    setState(() {
      isLoading = !isLoading;
    });
    var response = await transController.deleteTransaction(transaction);
    setState(() {
      isLoading = !isLoading;
    });
    var deletedTransResp = json.decode(response!.body);

    if (response.statusCode == 200) {
      var message = deletedTransResp['result']['message'];
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 134, 71),
      ));
      getTransactionList();
    } else if (response.statusCode == 400) {
      var message = deletedTransResp['result']['message'];
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xB7D8382D),
      ));
    } else {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
        content: Text(
          response.body.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xB7D8382D),
      ));
    }
  }
}
