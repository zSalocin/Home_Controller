import 'package:flutter/material.dart';
import 'firebase_call.dart';

class CONFIG extends StatefulWidget {
  const CONFIG({super.key});

  @override
  CONFIGState createState() => CONFIGState();
}

class CONFIGState extends State<CONFIG> {
  final formKey = GlobalKey<FormState>();

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
        child: Row(children: [
          Column(
            children: [
              Container(
                  //TODO imagem do esp e config do esp
                  ),
            ],
          ),
          Column(
            children: [
              //Aba de config
              Container(
                  color: Colors.black,
                  alignment: Alignment.centerRight,
                  child: Form(
                      key: formKey,
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () => blockCreate(context),
                              child: const Text("Create a Block")),
                          ElevatedButton(
                              onPressed: () => roomCreate(context),
                              child: const Text("Create a Room")),
                          ElevatedButton(
                              onPressed: () => elementCreate(context),
                              child: const Text("Create a Element")),
                        ],
                      )))
            ],
          ),
        ]),
      ),
    );
  }
}
