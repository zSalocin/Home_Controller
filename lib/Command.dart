import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'Salas.dart';
import 'class.dart';

class Command extends StatefulWidget {
  const Command({super.key});

  @override
  CommandState createState() => CommandState();
}

class CommandState extends State<Command> {
  final _database = FirebaseDatabase.instance.ref();

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
                        buildCard(context, Bloco.fromRTDB(item[index])),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })),
    );
  }

  Widget buildCard(
    BuildContext context,
    Bloco bloco,
  ) {
    final blocA101 = _database.child('Blocos/${bloco.name}');
    return Card(
      color: Colors.grey,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Salas(text: bloco.name),
                  ),
                );
              },
              child: Text(bloco.name),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
          ],
        ),
      ),
    );
  }
}
