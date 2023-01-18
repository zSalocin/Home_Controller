import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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


Future<void> blockCreate(BuildContext context) {

  final database = FirebaseDatabase.instance.ref();
  late TextEditingController control = TextEditingController();
  String text = "No Value Entered";
  void setText() {
      text = control.text;
  }

  void clearText() {
    control.clear();
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Create a Block'),
        actions: <Widget>[
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Block Name',
            ),
            controller: control,
          ),
          const SizedBox(
            width: 10,
            height: 10,
          ),
          ElevatedButton(onPressed: () async {
            Navigator.of(context).pop();
            setText();
            if(text != ''){
            clearText();
            final nextBlock = <String, dynamic>{
              'name': text,
              'luz': false,
            };
            database
                .child('/Blocos/$text')
                .update(nextBlock)
                .then((_) => print('block has saved'))
                .catchError(
                    (error) => print('error here $error'));
            await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Notificação'),
                  content:
                  const Text('O bloco foi criado com sucesso'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }else{
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Notificação'),
                    content:
                    const Text('A criação do bloco falhou'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
            }, child: const Text('Send'),)
        ],
      );
    },
  );
}

Future<void> roomCreate(BuildContext context) {

  final database = FirebaseDatabase.instance.ref();
  late TextEditingController control = TextEditingController();
  String text = "No Value Entered";
  List<String> item = [];

  void setText() {
    text = control.text;
  }

  final dbRef = FirebaseDatabase.instance
      .ref()
      .child("Blocos");
  dbRef.onValue.listen((event) => {
    event.snapshot.children.forEach((child) {
      if (child.key != null) {
        item.add(child.key.toString());
      }
    })
  });

  void clearText() {
    control.clear();
  }
  print('fui ex');
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
      return AlertDialog(
        title: const Text('Create a Room'),
        actions: <Widget>[
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Room Name',
            ),
            controller: control,
          ),
          const SizedBox(
            width: 10,
            height: 10,
          ),
          ElevatedButton(onPressed: () async {
            Navigator.of(context).pop();
            setText();
            clearText();
            final nextBlock = <String, dynamic>{
              'name': text,
              'luz': false,
            };
            database
                .child('/Blocos/$text')
                .update(nextBlock)
                .then((_) => print('block has saved'))
                .catchError(
                    (error) => print('error here $error'));
            await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Notificação'),
                  content:
                  const Text('O bloco foi criado com sucesso'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }, child: const Text('Send'),)
        ],
      );},);},);}
