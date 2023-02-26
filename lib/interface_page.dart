import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'class.dart';
import 'FireBase_Services.dart';

class INTERFACE extends StatefulWidget {
  const INTERFACE({super.key});

  @override
  INTERFACEState createState() => INTERFACEState();
}

class INTERFACEState extends State<INTERFACE> {
  final _database = FirebaseDatabase.instance.ref();
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Command Page"),
      ),
      body: Container(
          color: Colors.blue,
          child: StreamBuilder(
              stream: _database.child('Blocos').onValue,
              builder: (context, snapshot) {
                List item = [];
                if (snapshot.hasData) {
                  Map<String, dynamic> data =
                      (snapshot.data! as dynamic).snapshot.value;
                  data.forEach(
                      (index, data) => item.add({'key': index, ...data}));
                  return ListView.builder(
                    itemCount: item.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildCard(context, Block.fromRTDB(item[index])),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })),
    );
  }

  Widget buildCard(BuildContext context, Block bloco) {
    return Card(
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(bloco.name),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Do something when add button is pressed
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Do something when edit button is pressed
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Do something when delete button is pressed
                  },
                ),
              ],
            ),
          ],
        ),
        children: <Widget>[
          FutureBuilder(
            future: firebaseService.getRooms(bloco.name),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<String> rooms = snapshot.data as List<String>;
                print('rooms: $rooms');
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: rooms.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: EdgeInsets.all(0),
                        color: Colors.transparent,
                        child: ExpansionTile(
                          title: Text(rooms[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Do something when edit button is pressed
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Do something when delete button is pressed
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                print('error: ${snapshot.error}');
                return Text('Error: ${snapshot.error}');
              } else {
                print('loading...');
                return const SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator()));
              }
            },
          ),
          Card(
            margin: EdgeInsets.all(0),
            color: Colors.transparent,
            child: ListTile(
              title: Text(
                'Total de Salas:',
              ),
              subtitle: Text(
                'Total de elementos: ',
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//TODO adicionar funcionalidade aos botoes e botao para navegar para a pagina de rooms

//TODO adicionar botoes para acender ou apagar todos elementos dentro de um bloco e sala

//TODO adicionar contador para salas e elementos no bloco