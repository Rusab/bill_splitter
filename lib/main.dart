import 'package:bill_splitter/models/lists.dart';
import 'package:flutter/material.dart';
import 'package:bill_splitter/screens/homescreen.dart';
import 'dart:math';
import 'package:bill_splitter/colors.dart';
import 'package:provider/provider.dart';

final _random = Random();
int randnext(int max) => _random.nextInt(max);

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => UserList(),
    child: MaterialApp(
      home: const HomeScreen(),
    ),
  ));
}

// User Data class to use in UserEntry
class UserData {
  String name;
  double bill;
  double difference;
  int random_num;
  UserData(
      {required this.name,
      required this.bill,
      required this.difference,
      required this.random_num});
}

class Transaction {
  UserData user;
  int amount;

  Transaction({required this.user, required this.amount});
}

class ItemData {
  String name;
  double price;
  final List<Transaction> contribution;
  ItemData(
      {required this.name, required this.price, required this.contribution});
}

class InputPrompt extends StatefulWidget {
  final String title;
  final Widget child;
  final double height;
  final VoidCallback confirmFunction;
  InputPrompt({
    Key? key,
    required this.title,
    required this.child,
    required this.height,
    required this.confirmFunction,
  }) : super(key: key);

  @override
  State<InputPrompt> createState() => _InputPromptState();
}

class _InputPromptState extends State<InputPrompt> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      width: (MediaQuery.of(context).size.width - 30),
      height: widget.height,
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            child: Text(widget.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          Container(
            child: widget.child,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          Container(
            width: 120,
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: widget.confirmFunction,
              child: Text('Confirm'),
            ),
          )
        ]),
      ),
    );
  }
}
