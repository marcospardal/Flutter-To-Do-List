import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(new MaterialApp(
      home: Home(),
      theme: ThemeData(
          hintColor: Colors.white,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintStyle: TextStyle(color: Colors.white)))));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();
  final _nameController = TextEditingController();

  List _toDoList = [];
  String _newItemIcon = '';

  void addItem() {
    if (_toDoController.text != '') {
      setState(() {
        Map<String, dynamic> newToDo = Map();
        newToDo['title'] = _toDoController.text;
        _toDoController.text = '';
        newToDo['done'] = false;
        _toDoList.add(newToDo);
        newToDo['icon'] = _newItemIcon;
        _newItemIcon = '';

        _saveData();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        var res = json.decode(data);
        _toDoList = res['data'];
        _nameController.text = res['name'];
      });
    });
  }

  Icon _getIcon(value) {
    switch (value) {
      case 'work':
        return Icon(
          Icons.work,
          color: Colors.white,
        );
      case 'school':
        return Icon(
          Icons.school,
          color: Colors.white,
        );
      case 'person':
        return Icon(
          Icons.person,
          color: Colors.white,
        );
      case 'shopping_cart':
        return Icon(
          Icons.shopping_cart,
          color: Colors.white,
        );
    }

    return Icon(Icons.person, color: Colors.white);
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data =
        json.encode({'name': _nameController.text, 'data': _toDoList});
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Widget buildItem(context, index) {
    return Dismissible(
      secondaryBackground: Container(
        child: Container(
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                'Feito!',
                style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
              ),
              Icon(Icons.check, color: Colors.white),
            ],
          ),
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          if (direction == DismissDirection.startToEnd) {
            _toDoList.removeAt(index);
          } else if (direction == DismissDirection.endToStart) {
            _toDoList[index]['done'] = true;
          }

          _saveData();
        });
      },
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
          margin: EdgeInsets.only(left: 10),
          color: Colors.white,
          child: Container(
            child: Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.delete, color: Colors.white),
                  Text(
                    'Deletar!',
                    style:
                        TextStyle(fontFamily: 'Raleway', color: Colors.white),
                  )
                ],
              ),
            ),
          )),
      direction: DismissDirection.horizontal,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: _getIcon(_toDoList[index]['icon']),
                ),
                Text(
                  _toDoList[index]['title'],
                  style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
                ),
              ],
            )),
            Icon(
              Icons.check,
              color: _toDoList[index]['done'] ? Colors.white : Colors.black,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        title: Align(
          heightFactor: 1.8,
          alignment: Alignment.bottomLeft,
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(
                labelText: "Olá, ",
                labelStyle: TextStyle(
                    color: Colors.black, fontFamily: 'Raleway', fontSize: 25),
                fillColor: Colors.white),
            style: TextStyle(
                color: Colors.black, fontFamily: 'Raleway', fontSize: 25),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        controller: _toDoController,
                        decoration: InputDecoration(
                            labelText: "Nova Tarefa",
                            labelStyle: TextStyle(color: Colors.white),
                            fillColor: Colors.white),
                        style: TextStyle(color: Colors.white),
                      )),
                      RaisedButton(
                        onPressed: addItem,
                        child: Icon(Icons.add),
                        textColor: Colors.black,
                        color: Colors.white,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.work),
                        onPressed: () {
                          setState(() {
                            _newItemIcon = 'work';
                          });
                        },
                        color: _newItemIcon.contains('work')
                            ? Colors.white
                            : Colors.grey,
                      ),
                      IconButton(
                        icon: Icon(Icons.school),
                        onPressed: () {
                          setState(() {
                            _newItemIcon = 'school';
                          });
                        },
                        color: _newItemIcon.contains('school')
                            ? Colors.white
                            : Colors.grey,
                      ),
                      IconButton(
                        icon: Icon(Icons.person),
                        onPressed: () {
                          setState(() {
                            _newItemIcon = 'person';
                          });
                        },
                        color: _newItemIcon.contains('person')
                            ? Colors.white
                            : Colors.grey,
                      ),
                      IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          setState(() {
                            _newItemIcon = 'shopping_cart';
                          });
                        },
                        color: _newItemIcon.contains('shopping_cart')
                            ? Colors.white
                            : Colors.grey,
                      )
                    ],
                  )
                ],
              )),
          Expanded(
            child: ListView.builder(
              itemBuilder: buildItem,
              padding: EdgeInsets.only(top: 10),
              itemCount: _toDoList.length,
            ),
          )
        ],
      ),
    );
  }
}
