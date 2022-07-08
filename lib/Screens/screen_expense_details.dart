import 'package:flutter/material.dart';
import 'package:makeup_webapp/Model/Transaction/transaction_model/transaction_model.dart';
import 'package:makeup_webapp/Screens/screen_list_expense.dart';

class ScreenExpenseDetail extends StatelessWidget {
  TransactionModel transaction;

  ScreenExpenseDetail({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transaction.title ?? "",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 4, 134, 71),
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Text(
                  "€${transaction.amount}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            Text(
              "On ${transaction.date ?? ""}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            Text(
              "Note: ${transaction.note ?? ""}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
