import 'package:flutter/material.dart'; //interface para android
import 'package:projetonovo/models/item.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
   // items.add(Item(title: "item 1", done: false));
   // items.add(Item(title: "item 2", done: true));
   // items.add(Item(title: "item 2", done: true));
   // items.add(Item(title: "item 2", done: true));
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  var newTaskCtrl = TextEditingController();

_MyHomePageState() // inicializando uma vez só no construtor o load
{
  load();
}


void add(){  // função que adiciona novo objeto a lista
  if(newTaskCtrl.text.isEmpty) return;

  setState(() {
    widget.items.add(
      Item(
        title: newTaskCtrl.text, 
        done: false),
    );
    newTaskCtrl.text = "";
    save();
  });
}

void remove(int index)
{
  setState(() { //removendo o indice marcado
    widget.items.removeAt(index);
    save();
  });
}


//assíncrona (fila de atendimento)
  Future load() async
  {
    var prefs = await SharedPreferences.getInstance(); // aguarde ate o sharedpreferences não estiver carregado
    var data = prefs.getString('data');

    if (data != null){ //deixando passar em branco
      Iterable decoded = jsonDecode(data); // convertendo para json
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList(); //percorrendo a lista e trazendo el
      setState(() {
        widget.items = result;
      });
    }
  }

//assíncrona
save () async {
  var prefs = await SharedPreferences.getInstance(); // pegando instancia do prefs
  await prefs.setString('data', jsonEncode(widget.items)); //setando e transformando em uma lista
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

          return Dismissible(child: CheckboxListTile(  // criando checkbox
            title: Text(item.title),
            
            value: item.done,
            onChanged: (value){
              setState(() {
                item.done = value; // mudando o checkbox
                save();
              });
            },
          ),
          key: UniqueKey(), 
          background: Container(
            color: Colors.red.withOpacity(0.2)
          ),
          onDismissed: (direction){
            remove(index);
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

