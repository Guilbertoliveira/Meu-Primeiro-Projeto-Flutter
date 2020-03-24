import 'package:flutter/material.dart'; //interface para android
import 'package:projetonovo/models/item.dart'; 

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  var items = new List<Item>();
  MyHomePage(){
    items = [];
    items.add(Item(title: "item 1", done: false));
    items.add(Item(title: "item 2", done: true));
    items.add(Item(title: "item 2", done: true));
    items.add(Item(title: "item 2", done: true));
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var newTaskCtrl = TextEditingController();

void add(){  // função que adiciona novo objeto a lista
  if(newTaskCtrl.text.isEmpty) return;
  
  setState(() {
    widget.items.add(
      Item(
        title: newTaskCtrl.text, 
        done: false),
    );
    newTaskCtrl.text = "";
  });
}


  @override
  Widget build(BuildContext context) { //renderizo acabo n fica em um for... pra atualizar

    return Scaffold( //pagina, esqueleto da pagina
      appBar: AppBar(
        leading: Text("oi"), //canto esquerdo
        title: TextFormField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white,
          fontSize: 24,
          ),
          decoration: InputDecoration(
            labelText: "Nova Tarefa",
            labelStyle: TextStyle(
              color: Colors.white
              ),
          ),
        ), //titulo do appbar
        actions: <Widget>[
          Icon(Icons.plus_one), //adicionando um icone
        ],
      ), // adicionando appbar
      body: ListView.builder(

        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index){
          final item = widget.items[index]; // minimizando o codigo

          return CheckboxListTile(  // criando checkbox
            title: Text(item.title),
            key: Key(item.title),
            value: item.done,
            onChanged: (value){
              setState(() {
                item.done = value; // mudando o checkbox
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: add,  //adicionando botão
      child: Icon(Icons.add),
      backgroundColor: Colors.pink,
      ),
    );
  }
}

