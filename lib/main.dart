import 'package:flutter/material.dart';

const _primaryColor = Color(0xFF505050);
const _accentColor = Color(0xFF8CD95F);
const _deleteColor = Color(0xFFF97373);

void main() {
  runApp(MaterialApp(
    home: const HomeScreen(),
  ));
}

class UserEntry extends StatefulWidget {
  String name;
  double bill;
  double difference;
  final VoidCallback deleteUser;
  UserEntry(
      {Key? key,
      required this.name,
      required this.bill,
      required this.difference,
      required this.deleteUser})
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
                      child: Text('A',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Abdul Karim',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          Text('BDT 180.0', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_upward),
                        Text('20.0', style: TextStyle(fontSize: 20))
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
    return InputPrompt(
      title: 'Add New User',
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                labelText: 'User Name',
              ),
            ),
          )
        ],
      ),
      confirmFunction: () {},
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
  final List<Widget> _userList = [];
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
          UserEntry(
            name: 'Rusab',
            bill: 240.0,
            difference: 20.0,
            deleteUser: () => _removeUser(index, context),
          ));
      _key.currentState!.insertItem(0, duration: Duration(milliseconds: 200));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Bill Splitter'),
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
                          name: 'Rusab',
                          bill: 240.0,
                          difference: 20.0,
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
