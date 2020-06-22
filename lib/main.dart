import 'dart:io';

import 'package:expenses/widgets/chart.dart';
import 'package:expenses/widgets/new_transaction.dart';
import 'package:expenses/widgets/transactions_list.dart';
import 'package:expenses/widgets/user_transactions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/transactions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinProject',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              button: TextStyle(color: Colors.white),
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(fontFamily: 'OpenSans', fontSize: 20)))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(id: '1', title: 'Kek', amount: 22.33, date: DateTime.now()),
    Transaction(
        id: '2123123', title: 'Lol', amount: 23.43, date: DateTime.now()),
    Transaction(id: '24234', title: 'Lol', amount: 23.43, date: DateTime.now()),
    Transaction(
        id: '444324234', title: 'Lol', amount: 23.43, date: DateTime.now()),
    Transaction(id: '2123', title: 'Lol', amount: 23.43, date: DateTime.now()),
    Transaction(id: '3231', title: 'Lol', amount: 23.43, date: DateTime.now()),
    Transaction(
        id: '3', title: 'Cheburek', amount: 21.13, date: DateTime.now()),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
        date: chosenDate,
        amount: amount,
        id: DateTime.now().toString(),
        title: title);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      this._userTransactions.removeWhere((element) => element.id == id);
    });
  }

  Widget _buildLandscapeContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Show chart',
          style: Theme.of(context).textTheme.title,
        ),
        Switch.adaptive(
          activeColor: Theme.of(context).accentColor,
          value: _showChart,
          onChanged: (bool value) {
            setState(() {
              _showChart = value;
            });
          },
        )
      ],
    );
  }

  Widget _buildPortraitContent(MediaQueryData mediaQuery, AppBar appBar ) {
    return Container(
      child: Chart(_recentTransactions),
      height: (mediaQuery.size.height -
          appBar.preferredSize.height -
          mediaQuery.padding.top) *
          0.3,
    );
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: NewTransaction(_addTransaction));
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _startAddNewTransaction(context),
                  child: Icon(CupertinoIcons.add),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Coin project'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(
        transactions: _userTransactions,
        removeTransaction: _deleteTransaction,
      ),
    );

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (isLandscape) _buildLandscapeContent(),

            if (!isLandscape) _buildPortraitContent(mediaQuery, appBar),

            if (!isLandscape)
              txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      child: Chart(_recentTransactions),
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                    )
                  : txListWidget
//            Card(
//              color: Colors.amberAccent,
//              child: Text('List of tx'),
//            ),
          ],
        ),
      ),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
