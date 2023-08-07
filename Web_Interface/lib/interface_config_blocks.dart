import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'firebase_call.dart';
import 'firebase_services.dart';
import 'class.dart';
import 'alerts_and_checks.dart';

class BlockConfig extends StatefulWidget {
  final String blockName;

  const BlockConfig({super.key, required this.blockName});

  @override
  BlockConfigState createState() => BlockConfigState();
}

class BlockConfigState extends State<BlockConfig> {
  final formKey = GlobalKey<FormState>();
  final database = FirebaseDatabase.instance.ref();
  final FirebaseService firebaseService = FirebaseService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              return Row(
                children: [
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
                              .child('/Blocos/${widget.blockName}/Elements/')
                              .onValue,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data?.snapshot.value == null) {
                              return Center(
                                  child: TextButton(
                                onPressed: () {
                                  elementCreate(context);
                                },
                                child: const Text("Create a Button"),
                              ));
                            }
                            List item = [];
                            if (snapshot.hasData) {
                              Map<String, dynamic> data =
                                  (snapshot.data! as dynamic).snapshot.value;
                              data.forEach((index, data) =>
                                  item.add({'key': index, ...data}));
                              if (item.isEmpty) {
                                return Center(
                                    child: elementCreateDialogBox(
                                        context,
                                        'No Elements Found',
                                        'Please add a Element'));
                              } else {
                                return ListView.builder(
                                  itemCount: item.length,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      buildCard(
                                          context, Obj.fromRTDB(item[index])),
                                );
                              }
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
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


//Fazer layout resposivel