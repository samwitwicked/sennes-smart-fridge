import 'package:flutter/material.dart';
import 'item.dart';
import 'item_controller.dart';
import 'scan_page.dart';
import 'main.dart';
import 'item_widget.dart';
import 'dart:async';

class StartPage extends StatefulWidget {
  StartPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _StartPageState createState() => new _StartPageState();
}

enum _StartPagePopupMenu { Settings }

class _StartPageState extends State<StartPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  PersistentBottomSheetController addDialog;
  ItemController controller;
  ItemListModel listModel;
  String toAdd = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
                fontFamily: 'Chakra_Petch',
                fontWeight: FontWeight.w700,
                fontSize: 24.0),
          ),
          // backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          actions: [
            new PopupMenuButton(
              itemBuilder: (context) {
                return _StartPagePopupMenu.values
                    .map((option) => PopupMenuItem<_StartPagePopupMenu>(
                          value: option,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_getStartPagePopupMenuIcon(option)),
                              Container(width: 8.0),
                              Text(_getStartPagePopupMenuName(option)),
                            ],
                          ),
                        ))
                    .toList();
              },
              onSelected: (option) =>
                  _getStartPagePopupMenuFunction(option)(context),
            ),
          ],
        ),
        body: Material(
          type: MaterialType.card,
          color: Colors.white,
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          )),
          elevation: 8.0,
          clipBehavior: Clip.antiAlias,
          child: RefreshIndicator(
            child: listModel != null
                ? AnimatedList(
                    itemBuilder: _buildAnimatedItem,
                    key: _listKey,
                    initialItemCount: listModel.length,
                  )
                : ListView.builder(
                    itemCount: 15,
                    itemBuilder: _buildItem,
                    physics: PageScrollPhysics()),
            key: _refreshIndicatorKey,
            onRefresh: () {
              if (controller == null)
                return Future.delayed(Duration(seconds: 1));
              return controller.requestItemUpdates();
            },
          ),
        ),
        backgroundColor: SennesApp.primaryColor,
        floatingActionButton: FloatingActionButton(
          onPressed: _openAddItemDialog,
          tooltip: 'Add Item',
          child: new Icon(Icons.add),
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        ));
  }

  Widget _buildRemovedItem(
      Item item, BuildContext context, Animation<double> animation) {
    return ItemWidget(item: item, animation: animation);
  }

  Future loadModel() async {
    if (this.listModel != null) return;
    this.controller = controller ?? await ItemController.getInstance();
    setState(() {
      this.listModel = ItemListModel(controller, _listKey, _buildRemovedItem);
    });
  }

  @override
  void initState() {
    super.initState();
    loadModel().then((result) {
      Timer.periodic(Duration(milliseconds: 500), (timer) {
        controller?.requestItemUpdates();
      });
    });
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      Navigator.pop(context);
      _formKey.currentState.save();
      setState(() {
        if (toAdd == "") return;
        dynamic barcode = int.tryParse(toAdd);
        if (barcode != null) barcode = barcode.toString();
        controller?.increase(name: toAdd, barcode: barcode);
      });
    }
  }

  Widget _buildAnimatedItem(context, index, animation) {
    return ItemWidget(
      index: controller != null ? index : null,
      item: null,
      animation: animation,
    );
  }

  Widget _buildItem(context, index) {
    return _buildAnimatedItem(context, index, null);
  }

  void _openAddItemDialog() {
    showModalBottomSheet(
        context: _scaffoldKey.currentContext,
        builder: (builder) {
          return new Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScanPage()),
                            );
                          },
                        ),
                        Expanded(
                          child: TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: "Enter product name",
                              hintText: "e.g. Milk",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter a name.";
                              }
                            },
                            onSaved: (product) {
                              toAdd = product;
                            },
                            onFieldSubmitted: (value) {
                              _submit();
                            },
                          ),
                        ),
                        RaisedButton(
                          child: Text("Add"),
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        });
  }

  String _getStartPagePopupMenuName(_StartPagePopupMenu option) {
    switch (option) {
      case _StartPagePopupMenu.Settings:
        return "Settings";
      default:
        return option.toString();
    }
  }

  IconData _getStartPagePopupMenuIcon(_StartPagePopupMenu option) {
    switch (option) {
      case _StartPagePopupMenu.Settings:
        return Icons.settings;
      default:
        return Icons.border_all;
    }
  }

  _getStartPagePopupMenuFunction(_StartPagePopupMenu option) {
    switch (option) {
      case _StartPagePopupMenu.Settings:
        return (context) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ScanPage()),
          // );
        };
      default:
        return (context) {};
    }
  }
}
