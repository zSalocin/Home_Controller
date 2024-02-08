import 'package:flutter/material.dart';
import 'package:tcc_2023/backend_services.dart';
import 'package:tcc_2023/components.dart';
import 'package:tcc_2023/class.dart';

class RoomPage extends StatefulWidget {
  final String roomName;
  final String blockID;
  final String token;

  const RoomPage(
      {super.key,
      required this.roomName,
      required this.blockID,
      required this.token});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
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
              elementCreate(
                  context: context,
                  token: widget.token,
                  selectedBlock: widget.blockID,
                  roomName: widget.roomName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         BlockConfig(blockName: widget.blockName),
              //   ),
              // );
            },
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 68, 127, 175),
        child: FutureBuilder(
          future:
              getElementsforRoom(widget.token, widget.blockID, widget.roomName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: elementCreateDialogBox(
                    context,
                    widget.token,
                    'No Element Found',
                    'Please add an Element',
                    widget.blockID,
                    widget.roomName),
              );
            }

            List<Map<String, dynamic>> item = snapshot.data!;

            return ListView.builder(
              itemCount: item.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildCard(context, Obj.fromJson(item[index])),
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
                    element.elementName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    element.elementType,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: AnimatedContainer(
                duration: const Duration(
                    milliseconds:
                        200), // Duração da animação (pode ajustar conforme necessário)
                decoration: BoxDecoration(
                  color: element.stats ? Colors.green.withOpacity(0.5) : null,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  element.stats
                      ? Icons.power_settings_new
                      : Icons.power_settings_new_outlined,
                  color: element.stats ? Colors.green : null,
                ),
              ),
              onPressed: () async {
                dialogBox(
                    context,
                    'Notification',
                    await addRequest(
                        widget.token,
                        widget.blockID,
                        element.elementName,
                        '-1',
                        element.pin,
                        !element.stats));
              },
              // } else {
              //   // ignore: use_build_context_synchronously
              //   showDialog(
              //     context: context,
              //     builder: (BuildContext context) {
              //       return AlertDialog(
              //         title: const Text('Request Denied'),
              //         content: const Text(
              //             'Already have a request in line for this element'),
              //         actions: <Widget>[
              //           TextButton(
              //             onPressed: () {
              //               Navigator.pop(context);
              //             },
              //             child: const Text('OK'),
              //           ),
              //         ],
              //       );
              //     },
              //   );
              // }
              // },
              tooltip: element.stats
                  ? 'Turn Off'
                  : 'Turn On', // Tooltip a ser exibida
            ),
          ],
        ),
      ),
    );
  }
}

// Adicionar ao criar um elemento de dentro da pagina de sala, trave a criacao do elemento no bloco e sala

//TODO make the card color, background color, and bar color like all another apps, pick like a requerid maybe

//TODO fazer os testes restantes como o teste de encher uma sala de elementos a infinito pra ver o comportamento

//TOO adicionar layout resposivel 
