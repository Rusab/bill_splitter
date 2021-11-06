import 'package:flutter/material.dart';

const _primaryColor = Color(0xFF505050);
const _accentColor = Color(0xFF8CD95F);
const _deleteColor = Color(0xFFF97373);

void main() {
  runApp(const HomeScreen());
}

class UserEntry extends StatefulWidget {
  const UserEntry({Key? key}) : super(key: key);

  @override
  State<UserEntry> createState() => _UserEntryState();
}

class _UserEntryState extends State<UserEntry> {
  final double _height = 60;

  double _crossHeight = 0;
  double _crossWidth = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: _height,
        width: (MediaQuery.of(context).size.width - 30),
        margin: const EdgeInsets.all(10.0),
        child: GestureDetector(
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
      Padding(
        padding: const EdgeInsets.only(top: 10, right: 10),
        child: Align(
          alignment: Alignment.topRight,
          child: AnimatedContainer(
            height: _crossHeight,
            width: _crossWidth,
            duration: const Duration(milliseconds: 100),
            curve: Curves.bounceInOut,
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _userListState();
}

class _userListState extends State<HomeScreen> {
  final List<Widget> _userList = [];
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  void _addUser() {
    _userList.insert(0, UserEntry());
    _key.currentState!.insertItem(0, duration: Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                          child: UserEntry());
                    }),
              )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton.extended(
                        onPressed: () {},
                        backgroundColor: _primaryColor,
                        label: Text('Transactions')),
                    FloatingActionButton(
                        onPressed: _addUser,
                        backgroundColor: _primaryColor,
                        child: Icon(Icons.add, color: _accentColor))
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
