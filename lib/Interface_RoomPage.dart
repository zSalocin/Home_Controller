import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tcc_2023/alerts_and_checks.dart';
import 'package:tcc_2023/class.dart';
import 'package:tcc_2023/firebase_call.dart';
import 'package:tcc_2023/firebase_services.dart';
import 'config_page.dart';

//TODO make the card color, background color, and bar color like all another apps, pick like a requerid maybe
//TODO fazer os testes restantes como o teste de encher uma sala de elementos a infinito pra ver o comportamento

class RoomPage extends StatefulWidget {
  final String roomName;
  final String blocoName;

  const RoomPage({super.key, required this.roomName, required this.blocoName});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final database = FirebaseDatabase.instance.ref();
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.roomName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              elementCreate(context);
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
        color: const Color.fromARGB(255, 68, 127, 175),
        child: StreamBuilder(
          stream:
              database.child('/Blocos/${widget.blocoName}/Elements/').onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData ||
                snapshot.data?.snapshot.value == null) {
              return Center(
                child: elementCreateDialogBox(
                    context, 'No Element Found', 'Please add an Element'),
              );
            }
            List item = [];
            Map<String, dynamic> data =
                snapshot.data!.snapshot.value as Map<String, dynamic>;
            data.forEach((index, data) => item.add({'key': index, ...data}));
            item = item
                .where((element) => element['room'] == widget.roomName)
                .toList();
            return ListView.builder(
              itemCount: item.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildCard(context, Obj.fromRTDB(item[index])),
            );
          },
        ),
      ),
    );
  }

  buildCard(BuildContext context, Obj element) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    element.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    element.type,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                element.stats
                    ? Icons.power_settings_new
                    : Icons.power_settings_new_outlined,
              ),
              onPressed: () async {
                if (!await requestCheck(widget.blocoName, element.name)) {
                  firebaseService.createRequest(widget.blocoName, element.name,
                      element.pin, element.stats);
                } else {
                  dialogBox(context, 'Request Denied',
                      'Alrealdy have a request in line to this element');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
