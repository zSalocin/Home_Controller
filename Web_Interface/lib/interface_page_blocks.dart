import 'package:flutter/material.dart';
import 'package:tcc_2023/backend_services.dart';
import 'package:tcc_2023/components.dart';

import 'class.dart';
import 'interface_configpage_blocks.dart';
import 'interface_page_rooms.dart';
import 'interface_configpage_users.dart';

class INTERFACE extends StatefulWidget {
  final String token;
  const INTERFACE({super.key, required this.token});

  @override
  INTERFACEState createState() => INTERFACEState();
}

class INTERFACEState extends State<INTERFACE> {
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
              blockCreate(context, widget.token, () {
                setState(() {});
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserConfig(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.blue,
        child: FutureBuilder(
          future: getBlocks(widget.token),
          builder:
              (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: blockCreateDialogBox(context, widget.token,
                    'No Block Found', 'Please add an Block'),
              );
            }
            List<Map<String, dynamic>> item = snapshot.data!;

            return ListView.builder(
              itemCount: item.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildCard(context, Block.fromJson(item[index])),
            );
          },
        ),
      ),
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
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         // BlockConfig(blockName: bloco.name),
                    //   ),
                    // );
                  },
                  icon: const Icon(Icons.settings),
                ),
                IconButton(
                  onPressed: () {
                    roomCreate(
                        context: context,
                        token: widget.token,
                        blockName: bloco.blockId);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
        children: <Widget>[
          FutureBuilder(
            future: getRooms(widget.token, bloco.blockId),
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
                                        blockID: bloco.blockId,
                                        token: widget.token,
                                      ),
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

//remover botoes de luz e ar condicionado isso vai para config page

//TODO adiconar caso haja salas no bloco ao abrir o tile aparece um tile informando deseja criar uma sala.

//TODO adicionar botoes para acender ou apagar todos elementos dentro de um bloco e sala

//TODO adiconar erro caso ao aceder ou apagar todos elementos dentro de um bloco e sala, caso nao haja nenhum elemento

//TODO adicionar contador para salas e elementos no bloco

//TODO adicionar um check para verificar se a algum elemento ativo no bloco e alterar icono conforme

//TODO adicionar encase de erro caso nao encontre o firebase se possivel

//TOO adicionar layout resposivel 