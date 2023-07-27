import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tcc_2023/alerts_and_checks.dart';
import 'package:tcc_2023/firebase_call.dart';

import 'class.dart';
import 'firebase_services.dart';
import 'interface_roompage.dart';
import 'config_page.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              blockCreate(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CONFIG(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
          color: Colors.blue,
          child: StreamBuilder(
            stream: _database.child('Blocos').onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData ||
                  snapshot.data?.snapshot.value == null) {
                return Center(
                  child: blockCreateDialogBox(
                      context, 'No Block Found', 'Please add an Block'),
                );
              }
              List item = [];
              if (snapshot.hasData) {
                Map<String, dynamic> data =
                    (snapshot.data! as dynamic).snapshot.value;
                data.forEach(
                    (index, data) => item.add({'key': index, ...data}));
                if (item.isEmpty) {
                  return Center(
                      child: blockCreateDialogBox(
                          context, 'No Blocks Found', 'Please add a Block'));
                } else {
                  return ListView.builder(
                    itemCount: item.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildCard(context, Block.fromRTDB(item[index])),
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }

  Widget buildCard(BuildContext context, Block bloco) {
    return Card(
      child: ExpansionTile(
        title: Row(
          children: <Widget>[
            Text(bloco.name),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.lightbulb_circle_outlined),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.ac_unit_outlined),
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
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: rooms.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.001,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.orange,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                rooms[index],
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Do something when edit button is pressed
                                },
                                icon:
                                    const Icon(Icons.lightbulb_circle_outlined),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Do something when delete button is pressed
                                },
                                icon: const Icon(Icons.ac_unit_outlined),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RoomPage(
                                          roomName: rooms[index],
                                          blocoName: bloco.name),
                                    ),
                                  );
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
                return Text('Error: ${snapshot.error}');
              } else {
                return const SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator()));
              }
            },
          ),
          const Card(
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

//TODO adiconar caso haja salas no bloco ao abrir o tile aparece um tile informando deseja criar uma sala.

//TODO adicionar botoes para acender ou apagar todos elementos dentro de um bloco e sala

//TODO adiconar erro caso ao aceder ou apagar todos elementos dentro de um bloco e sala, caso nao haja nenhum elemento

//TODO adicionar contador para salas e elementos no bloco

//TODO adicionar um check para verificar se a algum elemento ativo no bloco e alterar icono conforme

//TODO adicionar encase de erro caso nao encontre o firebase se possivel

//TOO adicionar layout resposivel 