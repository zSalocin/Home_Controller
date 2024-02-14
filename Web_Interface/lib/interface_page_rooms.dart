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
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 20, 94, 155),
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
            item = item
                .where((element) =>
                    !element['elementName'].toLowerCase().contains('sensor'))
                .toList();

            if (item.isEmpty) {
              return const Center(
                child: Text('No non-sensor elements found.'),
              );
            }

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
    IconData iconData;
    Color? iconColor;

    // Verificar o tipo do elemento e definir o ícone correspondente
    if (element.elementType == 'Light') {
      iconData = element.stats ? Icons.lightbulb : Icons.lightbulb_outline;
      iconColor = element.stats ? Colors.yellow : Colors.grey;
    } else if (element.elementType == 'Air-Conditioner') {
      iconData = element.stats ? Icons.ac_unit : Icons.ac_unit_outlined;
      iconColor = element.stats ? Colors.blue : Colors.grey;
    } else {
      // Adicione condições para outros tipos de elementos, se necessário
      iconData = element.stats
          ? Icons.power_settings_new
          : Icons.power_settings_new_outlined;
      iconColor = element.stats ? Colors.green : null;
    }

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
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: element.stats
                      ? const Color.fromARGB(110, 51, 180, 55).withOpacity(0.5)
                      : null,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: iconColor,
                ),
              ),
              onPressed: () async {
                dialogBox(
                  context,
                  'Notification',
                  await addRequest(widget.token, widget.blockID,
                      element.elementName, '-1', element.pin, !element.stats),
                );
              },
              tooltip: element.stats ? 'Turn Off' : 'Turn On',
            ),
          ],
        ),
      ),
    );
  }
}


//TODO make the card color, background color, and bar color like all another apps, pick like a requerid maybe

//TOO adicionar layout resposivel 
