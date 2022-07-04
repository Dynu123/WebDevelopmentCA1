import 'package:flutter/material.dart';
import 'package:makeup_webapp/Screens/screen_add_transaction.dart';
import 'package:makeup_webapp/Screens/screen_expense_details.dart';
import 'package:makeup_webapp/Screens/screen_login.dart';

enum TransactionType {
  expense,
  income,
}

class ScreenListExpense extends StatelessWidget {
  final String title;
  final String amount;
  final TransactionType transactionType;
  final String? note;
  final String? transactionDate;

  const ScreenListExpense({
    Key? key,
    required this.title,
    required this.amount,
    required this.transactionType,
    this.transactionDate,
    this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    goToAddTransactionPage(context);
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
                          title: Text(amount),
                          subtitle: Text(transactionType.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  //edit item
                                  goToAddTransactionPage(context);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  //delete item
                                },
                                icon: const Icon(Icons.delete),
                              ),
                              IconButton(
                                  onPressed: () {
                                    //go to detail page
                                    goToDetailPage(context);
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
                itemCount: 50)));
  }

  signout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx1) => ScreenLogin()), (route) => false);
  }

  goToDetailPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => ScreenExpenseDetail(
              title: title,
              amount: amount,
              transactionType: transactionType,
              transactionDate: transactionDate ?? "",
              note: note ?? "",
            )));
  }

  goToAddTransactionPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => ScreenAddTransaction(),
    ));
  }

  deleteTransaction() {}
}
