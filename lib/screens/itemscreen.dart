import 'package:bill_splitter/main.dart';
import 'package:bill_splitter/models/lists.dart';
import 'package:flutter/material.dart';
import 'package:bill_splitter/colors.dart';
import 'package:provider/provider.dart';

class ItemEntry extends StatefulWidget {
  ItemData item;
  final VoidCallback deleteItem;
  ItemEntry({Key? key, required this.item, required this.deleteItem})
      : super(key: key);

  @override
  State<ItemEntry> createState() => _ItemEntryState();
}

class _ItemEntryState extends State<ItemEntry>
    with AutomaticKeepAliveClientMixin {
  final double _height = 80;

  double _crossHeight = 0;
  double _crossWidth = 0;

  @override
  Widget build(BuildContext context) {
    int index = _itemListState().__itemDataList.length;
    return Stack(children: [
      //main item entry
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: _height,
          width: (MediaQuery.of(context).size.width - 30),
          margin: const EdgeInsets.all(4.0),
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Item Name Field
                    Text(
                      widget.item.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text('BDT ' + widget.item.price.toString(),
                        style: TextStyle(fontSize: 20)),
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
              GestureDetector(onTap: widget.deleteItem),
            ]),
            decoration: new BoxDecoration(
              color: deleteColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      )
    ]);
  }

  bool get wantKeepAlive => true;
}

class newContributerDialog extends StatefulWidget {
  const newContributerDialog({Key? key}) : super(key: key);

  @override
  _newContributerDialogState createState() => _newContributerDialogState();
}

class _newContributerDialogState extends State<newContributerDialog> {
  @override
  Widget build(BuildContext context) {
    void setContributer(List<UserData> selectlist) {}

    return InputPrompt(
      title: 'Add New Contributer',
      height: 400,
      child: Consumer<UserList>(
          builder: (BuildContext context, UserList list, Widget? child) {
        return ListView.builder(
            itemCount: list.userList.length,
            itemBuilder: (context, index) {
              return Center(
                  child: Container(
                child: Center(
                    child: Text(
                  list.userList[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                )),
                height: 30,
                margin: EdgeInsets.all(10.0),
                width: (MediaQuery.of(context).size.width - 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(0, 0))
                  ],
                ),
              ));
            });
      }),
      confirmFunction: () {},
    );
  }
}

class newItemDialog extends StatelessWidget {
  const newItemDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController itemnameController = new TextEditingController();
    TextEditingController itemPriceController = new TextEditingController();

    void setValue(TextEditingController name, TextEditingController price) {
      Navigator.pop(context, [name.text, price.text]);
    }

    return InputPrompt(
      title: 'Add New item',
      height: 600,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: itemnameController,
              decoration: InputDecoration(
                focusColor: accentColor,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                labelText: 'Item Name',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: itemPriceController,
              decoration: InputDecoration(
                focusColor: accentColor,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                labelText: 'Price',
              ),
            ),
          ),
          Container(
            height: 200,
            child: Consumer<UserList>(
                builder: (BuildContext context, UserList list, Widget? child) {
              return ListView.builder(
                  itemCount: list.userList.length,
                  itemBuilder: (context, index) {
                    return Center(
                        child: Container(
                      child: Center(
                          child: Text(
                        list.userList[index].name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      )),
                      height: 30,
                      margin: EdgeInsets.all(10.0),
                      width: (MediaQuery.of(context).size.width - 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: Offset(0, 0))
                        ],
                      ),
                    ));
                  });
            }),
          )
        ],
      ),
      confirmFunction: () => setValue(itemnameController, itemPriceController),
    );
  }
}

class ItemScreen extends StatefulWidget {
  const ItemScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<ItemScreen> createState() => _itemListState();
}

class _itemListState extends State<ItemScreen>
    with AutomaticKeepAliveClientMixin {
  final List<ItemData> __itemDataList = [];
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    void lastScreen(context) {
      Navigator.pop(context);
    }

    void _remove_itemData(int index, context) {
      __itemDataList.removeAt(index);
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

    void _additem(int index, context) async {
      List nameInput = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
                backgroundColor: Colors.transparent, child: newItemDialog());
          });

      //check if null
      if (nameInput != null) {
        String item_name = nameInput[0].toString();
        String item_price = nameInput[1].toString();
        //only add to list if the string contains letters
        if (item_name.contains(new RegExp(r'[a-z]|[A-Z]'))) {
          __itemDataList.insert(
              0,
              ItemData(
                name: item_name,
                price: double.parse(item_price),
                contribution: [],
              ));
          _key.currentState!
              .insertItem(0, duration: Duration(milliseconds: 200));
        }
      }
    }

    return Scaffold(
        body: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedList(
                key: _key,
                itemBuilder: (context, index, animation) {
                  return SizeTransition(
                      key: UniqueKey(),
                      sizeFactor: animation,
                      child: ItemEntry(
                          item: __itemDataList[index],
                          deleteItem: () => _remove_itemData(index, context)));
                },
              ),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                      onPressed: () => _additem(0, context),
                      backgroundColor: primaryColor,
                      heroTag: 'item',
                      child: Icon(Icons.add, color: accentColor))
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
