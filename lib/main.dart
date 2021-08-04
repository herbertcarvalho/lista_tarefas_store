import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controler = TextEditingController();

  List _toDoList = [];
  
  @override
  void initState() {
    super.initState();
    
    _readData().then((value){
      setState(() {
        _toDoList = json.decode(value!);
      });
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = controler.text;
      controler.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: controler,
                  style: TextStyle(color: Colors.black, fontSize: 25.8),
                  decoration: InputDecoration(
                      labelText: 'Nova Tarefa', labelStyle: TextStyle(color: Colors.blue)),
                  onChanged: (text) {
                    print(controler.text);
                  },
                )),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: _toDoList.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(_toDoList[index]["title"]),
                      value: _toDoList[index]["ok"],
                      secondary: CircleAvatar(
                        child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
                      ),
                      onChanged: (q) {
                        setState(() {
                          _toDoList[index]["ok"] = q;
                          _saveData();
                        });
                      },
                    );
                  })),
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);

    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String?> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
