import 'package:flutter/material.dart';
import 'package:bill_splitter/screens/homescreen.dart';
import 'dart:math';
import 'package:bill_splitter/colors.dart';

final _random = Random();
int randnext(int max) => _random.nextInt(max);

void main() {
  runApp(MaterialApp(
    home: const HomeScreen(),
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

class InputPrompt extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      width: (MediaQuery.of(context).size.width - 30),
      height: height,
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            child: Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          Container(
            child: child,
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
              onPressed: confirmFunction,
              child: Text('Confirm'),
            ),
          )
        ]),
      ),
    );
  }
}
