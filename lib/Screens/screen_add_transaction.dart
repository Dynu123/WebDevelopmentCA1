import 'package:flutter/material.dart';
import 'package:makeup_webapp/ApiCalls/auth_controller.dart';
import 'package:makeup_webapp/ApiCalls/transaction_api_calls.dart';
import 'package:makeup_webapp/ApiCalls/transaction_controller.dart';
import 'package:makeup_webapp/Model/Transaction/transaction_model/transaction_model.dart';
import 'dart:convert';

import 'package:makeup_webapp/Screens/screen_list_expense.dart';

enum ActionType {
  add,
  edit,
}

class ScreenAddTransaction extends StatelessWidget {
  ActionType action;
  TransactionModel? transaction;

  ScreenAddTransaction({
    Key? key,
    required this.action,
    this.transaction,
  }) : super(key: key);

  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  String? typeController;

  final _dateController = TextEditingController();

  final _noteController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (action == ActionType.edit) {
      if (transaction == null) {
      } else {
        if (transaction?.transactionId != null) {
          _titleController.text = transaction!.title!;
          _amountController.text = transaction!.amount!;
          typeController = transaction!.type!;
          _dateController.text = transaction!.date!;
          _noteController.text = transaction!.note!;
        } else {
          Navigator.of(context).pop();
        }
      }
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: action == ActionType.add
            ? const Text("Add new transactions")
            : const Text("Edit transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: "Enter title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field cannot be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    hintText: "Enter amount",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field cannot be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                    value: typeController,
                    validator: (value) {
                      if (value == null || value.toString().isEmpty) {
                        return "Field cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Select transaction type",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      typeController = value.toString();
                    },
                    items: TransactionType.values.map((e) {
                      return DropdownMenuItem(
                        value: e.name,
                        child: Text(e.name),
                      );
                    }).toList()),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    hintText: "Enter date(optional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    hintText: "Enter note (optional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        //action
                        if (_formKey.currentState!.validate()) {
                          //call add/edit transaction api
                          if (action == ActionType.add) {
                            addNewTransaction();
                          } else {
                            TransactionModel editTransaction =
                                TransactionModel();
                            editTransaction.transactionId =
                                transaction?.transactionId;
                            editTransaction.title = _titleController.text;
                            editTransaction.amount = _amountController.text;
                            editTransaction.type = typeController!;
                            editTransaction.date = _dateController.text;
                            editTransaction.note = _noteController.text;
                            editTransaction.userId = transaction?.userId;
                            updateTransaction(editTransaction);
                          }
                        } else {
                          print("no data");
                        }
                      },
                      child: action == ActionType.add
                          ? const Text("Add")
                          : const Text("Update"),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addNewTransaction() async {
    final title = _titleController.text;
    final amount = _amountController.text;
    final type = typeController!;
    final date = _dateController.text;
    final note = _noteController.text;
    TransactionController transController = TransactionController();

    var response = await transController.addTransaction(
        title, amount, type, date, note, LoginUserDB.instance.userModel!.id);
    var newTransResp = json.decode(response!.body);
    if (response.statusCode == 200) {
      if (newTransResp['result']['code'] == '200') {
        var message = newTransResp['result']['message'];
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(content: Text(message)));
        Navigator.of(_scaffoldKey.currentContext!).pop();
      } else {
        var message = newTransResp['result']['message'];
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } else if (response.statusCode == 400) {
      var message = newTransResp['result']['message'];
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(message)));
    } else {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(response.body.toString())));
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    TransactionController transController = TransactionController();
    var response = await transController.updateTransaction(transaction);
    var tranResp = json.decode(response!.body);
    
    if (response.statusCode == 200) {
      if (tranResp['result']['code'] == '200') {
        var message = tranResp['result']['message'];
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(content: Text(message)));
        Navigator.of(_scaffoldKey.currentContext!).pop();
      } else {
        var message = tranResp['result']['message'];
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } else if (response.statusCode == 400) {
      var message = tranResp['result']['message'];
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(message)));
    } else {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(response.body.toString())));
    }
  }

  Future<void> addTransaction() async {
    final title = _titleController.text;
    final amount = _amountController.text;
    final type = typeController;
    final date = _dateController.text;
    final note = _noteController.text;

    TransactionModel transactionModel;
    transactionModel = TransactionModel.create(
        title: title,
        amount: amount,
        type: type,
        note: note,
        date: date,
        userId: LoginUserDB.instance.userModel?.id);

    final result = await TransactionDB().addNewTransaction(transactionModel);
    print('result== $result');
  }
}
