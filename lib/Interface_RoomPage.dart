import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tcc_2023/class.dart';

class RoomPage extends StatefulWidget {
  final String roomName;
  final String blocoName;

  const RoomPage({super.key, required this.roomName, required this.blocoName});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName),
      ),
      body: Container(
          color: Colors.blue,
          child: StreamBuilder(
              stream: database
                  .child('/Blocos/${widget.blocoName}/Elements/')
                  .onValue,
              builder: (context, snapshot) {
                List item = [];
                if (snapshot.hasData) {
                  Map<String, dynamic> data =
                      (snapshot.data! as dynamic).snapshot.value;
                  data.forEach(
                      (index, data) => item.add({'key': index, ...data}));
                  item = item
                      .where((element) => element['room'] == widget.roomName)
                      .toList();
                  return ListView.builder(
                    itemCount: item.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildCard(context, Obj.fromRTDB(item[index])),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })),
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
              onPressed: () {
                //TODO fazer a parte do firebase
              },
            ),
          ],
        ),
      ),
    );
  }
}
