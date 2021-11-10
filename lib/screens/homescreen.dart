import 'package:bill_splitter/main.dart';
import 'package:bill_splitter/screens/itemscreen.dart';
import 'package:flutter/material.dart';
import 'package:bill_splitter/colors.dart';

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
    void nextScreen(context) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ItemScreen()));
    }

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
                        color: userColor[widget.user.random_num],
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
                        Icon(Icons.arrow_circle_up_rounded),
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
                    _crossHeight = 25.0;
                    _crossWidth = 25.0;
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
        padding: const EdgeInsets.only(top: 15, right: 15),
        child: Align(
          alignment: Alignment.topRight,
          //close button popup
          child: AnimatedContainer(
            height: _crossHeight,
            width: _crossWidth,
            duration: const Duration(milliseconds: 100),
            curve: Curves.bounceInOut,
            child: Stack(alignment: Alignment.center, children: [
              Icon(
                Icons.close_rounded,
                color: Colors.white,
              ),
              GestureDetector(onTap: widget.deleteUser),
            ]),
            decoration: new BoxDecoration(
              color: deleteColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
      SizedBox(
          height: 600,
          width: 600,
          child: GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) =>
                nextScreen(context),
          )),
    ]);
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
      height: 250,
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
      _userList.removeAt(index);
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
      var nameInput = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
                backgroundColor: Colors.transparent, child: newUserDialog());
          });

      //check if null
      if (nameInput != null) {
        String user_name = nameInput.toString();
        //only add to list if the string contains letters
        if (user_name.contains(new RegExp(r'[a-z]|[A-Z]'))) {
          _userList.insert(
              0,
              UserData(
                name: user_name,
                bill: 0.0,
                difference: 0.0,
                random_num: randnext(userColor.length - 1),
              ));
          _key.currentState!
              .insertItem(0, duration: Duration(milliseconds: 200));
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Bill Splitter',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: primaryColor,
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
                      heroTag: 'transactions',
                      backgroundColor: primaryColor,
                      label: Text('Transactions')),
                  FloatingActionButton(
                      onPressed: () => _addUser(0, context),
                      heroTag: 'user',
                      backgroundColor: primaryColor,
                      child: Icon(Icons.add, color: accentColor))
                ],
              ),
            ),
          ],
        ));
  }
}
