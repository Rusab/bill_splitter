import 'package:flutter/material.dart';
import 'dart:math';

const _primaryColor = Color(0xFF505050);
const _accentColor = Color(0xFF8CD95F);
const _deleteColor = Color(0xFFF97373);

const List<Color> _userColor = [
  Color(0xFF89B5AF),
  Color(0xFF9E7777),
  Color(0xFF96C7C1),
  Color(0xFFD0CAB2),
  Color(0xFFFFC898),
  Color(0xFFC37B89),
  Color(0xFFBCCC9A),
  Color(0xFF316B83),
  Color(0xFF6D8299),
  Color(0xFF8CA1A5),
];

final _random = new Random();
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
  UserData({required this.name, required this.bill, required this.difference});
}

class UserEntry extends StatefulWidget {
  UserData user;
  final VoidCallback deleteUser;
  UserEntry({Key? key, required this.user, required this.deleteUser})
      : super(key: key);

  @override
  State<UserEntry> createState() => _UserEntryState();
}

class _UserEntryState extends State<UserEntry> {
  final double _height = 80;

  double _crossHeight = 0;
  double _crossWidth = 0;

  @override
  Widget build(BuildContext context) {
    int index = _userListState()._userList.length;
    return Stack(children: [
      //main user entry
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: _height,
          width: (MediaQuery.of(context).size.width - 30),
          margin: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: Text(widget.user.name[0],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _userColor[randnext(_userColor.length - 1)],
                        shape: BoxShape.circle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.user.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          Text('BDT ' + widget.user.bill.toString(),
                              style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_upward),
                        Text(widget.user.difference.toString(),
                            style: TextStyle(fontSize: 20))
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _crossHeight = 0.0;
                    _crossWidth = 0.0;
                  });
                },
                onLongPress: () {
                  setState(() {
                    _crossHeight = 20.0;
                    _crossWidth = 20.0;
                  });
                },
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(_height)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 4,
                  blurRadius: 6,
                  offset: Offset(0, 0))
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, right: 10),
        child: Align(
          alignment: Alignment.topRight,
          //close button popup
          child: AnimatedContainer(
            height: _crossHeight,
            width: _crossWidth,
            duration: const Duration(milliseconds: 100),
            curve: Curves.bounceInOut,
            child: GestureDetector(onTap: widget.deleteUser),
            decoration: new BoxDecoration(
              color: _deleteColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      )
    ]);
  }
}

class InputPrompt extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback confirmFunction;
  InputPrompt({
    Key? key,
    required this.title,
    required this.child,
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
      height: 250,
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
                color: _primaryColor,
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

class newUserDialog extends StatelessWidget {
  const newUserDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = new TextEditingController();

    void setName(TextEditingController username_cont) {
      Navigator.pop(context, username_cont.text);
    }

    return InputPrompt(
      title: 'Add New User',
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                labelText: 'User Name',
              ),
            ),
          )
        ],
      ),
      confirmFunction: () => setName(usernameController),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<HomeScreen> createState() => _userListState();
}

class _userListState extends State<HomeScreen> {
  final List<UserData> _userList = [];
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    void _removeUser(int index, context) {
      _key.currentState!.removeItem(index, (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: Container(
            height: 60,
            width: (MediaQuery.of(context).size.width - 30),
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 4,
                    blurRadius: 6,
                    offset: Offset(0, 0))
              ],
            ),
          ),
        );
      }, duration: Duration(milliseconds: 300));
    }

    void _addUser(int index, context) async {
      var user_name = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
                backgroundColor: Colors.transparent, child: newUserDialog());
          });

      _userList.insert(
          0,
          UserData(
            name: user_name,
            bill: 0.0,
            difference: 0.0,
          ));
      _key.currentState!.insertItem(0, duration: Duration(milliseconds: 200));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Bill Splitter',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: _primaryColor,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedList(
                key: _key,
                initialItemCount: 0,
                itemBuilder: (context, index, animation) {
                  return SizeTransition(
                      key: UniqueKey(),
                      sizeFactor: animation,
                      child: UserEntry(
                          user: _userList[index],
                          deleteUser: () => _removeUser(index, context)));
                },
              ),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton.extended(
                      onPressed: () {},
                      backgroundColor: _primaryColor,
                      label: Text('Transactions')),
                  FloatingActionButton(
                      onPressed: () => _addUser(0, context),
                      backgroundColor: _primaryColor,
                      child: Icon(Icons.add, color: _accentColor))
                ],
              ),
            ),
          ],
        ));
  }
}
