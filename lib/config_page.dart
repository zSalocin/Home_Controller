import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'firebase_call.dart';
import 'firebase_services.dart';
import 'class.dart';

class CONFIG extends StatefulWidget {
  const CONFIG({super.key});

  @override
  CONFIGState createState() => CONFIGState();
}

class CONFIGState extends State<CONFIG> {
  final formKey = GlobalKey<FormState>();
  final database = FirebaseDatabase.instance.ref();
  final FirebaseService firebaseService = FirebaseService();
  String selectedBlock = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getBuildingList();
  }

  Future<void> getBuildingList() async {
    final item = await firebaseService.getBlocks();
    setState(() {
      selectedBlock = item.isNotEmpty ? item[0] : "";
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isLoading
          ? null
          : AppBar(
              centerTitle: true,
              title: const Text("Config"),
            ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.greenAccent,
        child: FutureBuilder<List<String>>(
          future: firebaseService.getBlocks(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final item = snapshot.data;
              return Row(children: [
                Column(
                  children: [
                    Container(
                        color: Colors.blue,
                        alignment: Alignment.centerRight,
                        height: MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.top,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: StreamBuilder(
                            stream: database
                                .child('Blocos/$selectedBlock/Elements')
                                .onValue,
                            builder: (context, snapshot) {
                              List item = [];
                              if (snapshot.hasData) {
                                Map<String, dynamic> data =
                                    (snapshot.data! as dynamic).snapshot.value;
                                data.forEach((index, data) =>
                                    item.add({'key': index, ...data}));
                                return ListView.builder(
                                  itemCount: item.length,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      buildCard(
                                          context, Obj.fromRTDB(item[index])),
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            })),
                  ],
                ),
                Column(
                  children: [
                    //Aba de config
                    Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      height: (MediaQuery.of(context).size.height -
                              AppBar().preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.1,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Form(
                        key: formKey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            ElevatedButton(
                                onPressed: () => blockCreate(context),
                                child: const Text("Create a Block")),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            ElevatedButton(
                                onPressed: () => roomCreate(context),
                                child: const Text("Create a Room")),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            ElevatedButton(
                                onPressed: () => elementCreate(context),
                                child: const Text("Create a Element")),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'block name',
                                ),
                                items: item!.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) => selectedBlock = value!,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a block';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      //TODO imagem do esp e config do esp
                      height: (MediaQuery.of(context).size.height -
                              AppBar().preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.9,
                      width: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.pink,
                    ),
                  ],
                ),
              ]);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget buildCard(
    BuildContext context,
    Obj element,
  ) {
    // ignore: prefer_const_constructors
    return Card(
      color: Colors.grey,
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.1,
          child: Column(children: [
            Text("Element Name: ${element.name}"),
            Row(children: [
              Text("Pin: ${element.pin}"),
              Text("Room: ${element.room}"),
              Text("Element Type: ${element.type}"),
              Text("Current Status: ${element.stats}"),
            ]),
          ])),
    );
  }
}
