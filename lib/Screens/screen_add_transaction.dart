import 'package:flutter/material.dart';
import 'package:makeup_webapp/ApiCalls/auth_controller.dart';
import 'package:makeup_webapp/ApiCalls/transaction_api_calls.dart';
import 'package:makeup_webapp/ApiCalls/transaction_controller.dart';
import 'package:makeup_webapp/Model/Transaction/transaction_model/transaction_model.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:makeup_webapp/Screens/screen_list_expense.dart';

enum ActionType {
  add,
  edit,
}

class ScreenAddTransaction extends StatefulWidget {
  ActionType action;
  TransactionModel? transaction;

  ScreenAddTransaction({
    Key? key,
    required this.action,
    this.transaction,
  }) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  String? typeController;

  final _noteController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedDateString;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.action == ActionType.edit) {
      if (widget.transaction == null) {
        Navigator.of(context).pop();
      } else {
        if (widget.transaction?.transactionId != null) {
          _titleController.text = widget.transaction!.title!;
          _amountController.text = widget.transaction!.amount!;
          typeController = widget.transaction!.type!;
          selectedDateString = widget.transaction?.date!;
          _noteController.text = widget.transaction!.note!;
        } else {
          Navigator.of(context).pop();
        }
      }
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SizedBox(
            width: 400,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: 400,
                    decoration: const BoxDecoration(color: Colors.black),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.action == ActionType.add
                              ? "Add new transaction"
                              : "Edit transaction",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
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
                    cursorColor: Colors.black,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Color.fromARGB(255, 4, 134, 71),
                        ),
                        label: Text(
                          selectedDateString == null
                              ? "Select date"
                              : selectedDateString!,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 4, 134, 71),
                          ),
                        ),
                        onPressed: () async {
                          final selectedDateTemp = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            lastDate: DateTime.now(),
                          );
                          if (selectedDateTemp == null) {
                            return;
                          } else {
                            setState(() {
                              DateFormat dateFormat = DateFormat("dd/MMM/yyyy");
                              selectedDateString =
                                  dateFormat.format(selectedDateTemp);
                              widget.transaction?.title = _titleController.text;
                              widget.transaction?.date = selectedDateString;
                              widget.transaction?.amount =
                                  _amountController.text;
                              widget.transaction?.type = typeController;
                              widget.transaction?.note = _noteController.text;
                            });
                          }
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
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
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          //action
                          if (_formKey.currentState!.validate()) {
                            //call add/edit transaction api
                            if (widget.action == ActionType.add) {
                              addNewTransaction();
                            } else {
                              TransactionModel editTransaction =
                                  TransactionModel();
                              editTransaction.transactionId =
                                  widget.transaction?.transactionId;
                              editTransaction.title = _titleController.text;
                              editTransaction.amount = _amountController.text;
                              editTransaction.type = typeController!;
                              editTransaction.date = selectedDateString;
                              editTransaction.note = _noteController.text;
                              editTransaction.userId =
                                  widget.transaction?.userId;
                              updateTransaction(editTransaction);
                            }
                          } else {
                            // ignore: avoid_print
                            print("no data");
                          }
                        },
                        child: isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : widget.action == ActionType.add
                                ? const Text("Add")
                                : const Text("Update"),
                      )),
                ],
              ),
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
    final date = selectedDateString;
    final note = _noteController.text;
    TransactionController transController = TransactionController();
    setState(() {
      isLoading = !isLoading;
    });
    var response = await transController.addTransaction(
        title, amount, type, date, note, LoginUserDB.instance.userModel!.id);
    setState(() {
      isLoading = !isLoading;
    });
    var newTransResp = json.decode(response!.body);
    if (response.statusCode == 200) {
      if (newTransResp['result']['code'] == '200') {
        var message = newTransResp['result']['message'];
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 4, 134, 71),
        ));
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
            .showSnackBar(SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 4, 134, 71),
        ));
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
}
