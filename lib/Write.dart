

import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

import 'Firebase_Methods.dart';

class Write extends StatefulWidget {
  const Write({super.key});
  @override
  WriteState createState() => WriteState();
}

class WriteState extends State<Write> {
  final database = FirebaseDatabase.instance.ref();
  late TextEditingController control = TextEditingController();
  String text = "No Value Entered";

  @override
  Widget build(BuildContext context) {
    double espaco = MediaQuery.of(context).size.width * 0.01;
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;
    String bloco = 'a';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Lets Write or Try"),
      ),
      body: Container(
        height: altura,
        width: largura,
        color: Colors.greenAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              color: Colors.grey,
              child: SizedBox(
                height: altura * 0.11,
                width: largura * 1,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: espaco,
                    ),
                    const Text("Criar novo bloco:"),
                    SizedBox(
                      width: espaco,
                    ),
                     ElevatedButton(onPressed: () async {
                       blockCreate(context);
                    }, child: const Text('create a block'),)
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.grey,
              child: SizedBox(
                width: largura * 0.6,
                height: altura * 0.1,
                child: Center(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: espaco,
                      ),
                      const Text('Defina o bloco'),
                      SizedBox(
                        width: espaco,
                      ),
                      SizedBox(
                        width: largura * 0.05,
                        height: altura * 0.05,
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                          size: 12.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                        //TODO colocar scroll roll pra selecionar blocos pre criados
                      ),
                      SizedBox(
                        width: espaco,
                      ),
                      const Text('nome da sala'),
                      SizedBox(
                        width: espaco,
                      ),
                      SizedBox(
                        width: largura * 0.3,
                        height: altura * 0.1,
                        child: Center(
                          child: TextField(
                            obscureText: false,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Sala name',
                            ),
                            onSubmitted: (String sala){
                              final nextSala = <String, dynamic>{
                                'name': sala,
                                'luz': false,
                                'air': false,
                              };
                              database
                                  .child('/Blocos/$bloco/Salas/$sala')
                                  .update(nextSala)
                                  .then((_) => print('sala has saved'))
                                  .catchError(
                                      (error) => print('error here $error'));
                              },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: espaco,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: Colors.grey,
              child: SizedBox(
                width: largura * 0.6,
                height: altura * 0.1,
                child: Center(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: espaco,
                      ),
                      const Text('Defina o bloco'),
                      SizedBox(
                        width: espaco,
                      ),
                      SizedBox(
                        width: largura * 0.05,
                        height: altura * 0.05,
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                          size: 12.0,
                          semanticLabel:
                          'Text to announce in accessibility modes',
                        ),
                        //TODO colocar scroll roll pra selecionar blocos pre criados
                      ),
                      SizedBox(
                        width: espaco,
                      ),
                     const Text('Defina a sala'),
                      SizedBox(
                        width: espaco,
                      ),
                      const Text('defina o tipo de objeto'),
                      const Text('aqui vai o botao'),
                      SizedBox(
                        width: espaco,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}