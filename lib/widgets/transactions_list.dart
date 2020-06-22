import 'package:expenses/models/transactions.dart';
import 'package:expenses/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function removeTransaction;

  TransactionList(
      {@required this.transactions, @required this.removeTransaction});

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Text('No transactions added yet!',
                      style: Theme.of(context).textTheme.title),
                  SizedBox(height: 20),
                  Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset('lib/assets/images/waiting.png',
                          fit: BoxFit.cover))
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TransactionItem(transaction: transactions[index], removeTransaction: removeTransaction);
            },
            itemCount: transactions.length,
          );
  }
}

