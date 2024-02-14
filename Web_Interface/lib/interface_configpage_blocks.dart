import 'package:flutter/material.dart';
import 'package:tcc_2023/backend_services.dart';
import 'class.dart';
import 'components.dart';

class BlockConfig extends StatefulWidget {
  final String token;
  final Block block;

  const BlockConfig({super.key, required this.token, required this.block});

  @override
  BlockConfigState createState() => BlockConfigState();
}

class BlockConfigState extends State<BlockConfig> {
  final formKey = GlobalKey<FormState>();
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
        color: const Color.fromARGB(255, 20, 94, 155),
        child: Row(
          children: [
            Expanded(
              flex: 60,
              child: Column(
                children: [
                  Expanded(
                    flex: 60,
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 40,
                            child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 5),
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: const Text("Create a new Room"),
                                    ),
                                    const SizedBox(height: 5),
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: const Text("Create a new Element"),
                                    ),
                                    const SizedBox(height: 5),
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: const Text("Add a Request"),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                )),
                          ),
                          Expanded(
                            flex: 60,
                            child: SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: FutureBuilder(
                                future: getRooms(
                                    widget.token, widget.block.blockId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.data == null ||
                                      snapshot.data!.isEmpty) {
                                    return Center(
                                      child: roomCreateDialogBox(
                                        context,
                                        widget.token,
                                        widget.block.blockId,
                                        'No room Found',
                                        'Please add an room',
                                      ),
                                    );
                                  }

                                  List<String> items = snapshot.data!;

                                  return ListView(
                                    children: [
                                      if (items.isNotEmpty)
                                        const Card(
                                          color: Colors.grey,
                                          child: ListTile(
                                            title: Text(
                                              "Rooms",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            dense: true,
                                          ),
                                        ),
                                      for (var item in items)
                                        buildcardRooms(context, item),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 40,
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 40,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Block Name: ${widget.block.name}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'BlockId: ${widget.block.blockId}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                          'Current Element Number: ${widget.block.elementNumber}'),
                                      Text(
                                          'Current Room Number: ${widget.block.roomNumber}'),
                                      // TODO put this inforamtion in the card
                                      // Text(
                                      //     'Microcontroller Type: ${widget.block.}'),
                                      // Text(
                                      //     'Available Pins: ${availablePins.join(', ')}'),
                                      // Text(
                                      //     'Available Analog Pins: ${availableAnalogPins.join(', ')}'),
                                    ],
                                  ),
                                ),
                              )),
                          Expanded(
                            flex: 60,
                            child: Container(
                              alignment: Alignment.center,
                              child: FutureBuilder(
                                future: getRequest(
                                    widget.token, widget.block.blockId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.data == null ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                      child: Card(
                                        color: Colors.grey,
                                        child: ListTile(
                                          title: Text(
                                            "Dont have any Request",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          dense: true,
                                        ),
                                      ),
                                    );
                                  }

                                  List<Map<String, dynamic>> item =
                                      snapshot.data!;
                                  return ListView.builder(
                                    itemCount: item.length + 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == 0) {
                                        return const Card(
                                          color: Colors.grey,
                                          child: ListTile(
                                            title: Text(
                                              "Requests",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            dense: true,
                                          ),
                                        );
                                      } else {
                                        return buildcardRequest(
                                            context,
                                            Request.fromJson(item[index -
                                                1])); // Adjust index for item list
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 40,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: FutureBuilder(
                        future: getElements(widget.token, widget.block.blockId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              (snapshot.data as List<Map<String, dynamic>>)
                                  .isEmpty) {
                            return Center(
                              child: TextButton(
                                onPressed: () {
                                  elementCreate(
                                    token: widget.token,
                                    context: context,
                                    selectedBlock: widget.block.blockId,
                                  );
                                },
                                child: const Text("Create a element"),
                              ),
                            );
                          }

                          List<Obj> sensors = [];
                          List<Obj> actuators = [];

                          for (var elementMap
                              in snapshot.data as List<Map<String, dynamic>>) {
                            Obj element = Obj.fromJson(elementMap);
                            bool isSensor = element.elementType
                                .toLowerCase()
                                .contains('sensor');
                            if (isSensor) {
                              sensors.add(element);
                            } else {
                              actuators.add(element);
                            }
                          }

                          return ListView(
                            children: [
                              if (sensors.isNotEmpty)
                                const Card(
                                  color: Colors.grey,
                                  child: ListTile(
                                    title: Text(
                                      "Sensors",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    dense: true,
                                  ),
                                ),
                              for (var sensor in sensors)
                                buildCardSensor(context, sensor, actuators),
                              if (actuators.isNotEmpty)
                                const Card(
                                  color: Colors.grey,
                                  child: ListTile(
                                    title: Text(
                                      "Actuators",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    dense: true,
                                  ),
                                ),
                              for (var actuator in actuators)
                                buildCardActuator(context, actuator),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //separar em 2 um para os sensores e o outro para o resto
  Widget buildCardActuator(BuildContext context, Obj element) {
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
                    "Type: ${element.elementType}   Pin: ${element.pin}",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.delete_outline)),
            IconButton(
              icon: AnimatedContainer(
                duration: const Duration(
                    milliseconds:
                        200), // Duração da animação (pode ajustar conforme necessário)
                decoration: BoxDecoration(
                  color: element.enable ? Colors.green.withOpacity(0.5) : null,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  element.enable
                      ? Icons.power_settings_new
                      : Icons.power_settings_new_outlined,
                  color: element.stats ? Colors.green : null,
                ),
              ),
              onPressed: () async {
                // await firebaseService.setElement(widget.blockId, element.room,         ADD A METHOD TO CHANGE THE ENABLE OF ELEMENT IN API
                //     element.name, element.type, element.pin, !element.enable);
              },
              tooltip: element.enable
                  ? 'Turn Off'
                  : 'Turn On', // Tooltip a ser exibida
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, String>>> getActuatorsByAttachPins(
      List<Obj> allElements, List<int> attachPins) async {
    List<Map<String, String>> actuatorsDetails = [];
    List<Obj> actuators = allElements.where((element) {
      return attachPins.contains(element.pin);
    }).toList();

    for (var actuator in actuators) {
      // Assuming actuator has name and type properties
      actuatorsDetails.add({
        'name': actuator.elementName,
        'type': actuator.elementType,
        'pin': actuator.pin.toString(),
      });
    }

    return actuatorsDetails;
  }

  Widget buildCardSensor(
      BuildContext context, Obj element, List<Obj> actuators) {
    return Card(
      child: ExpansionTile(
        title: Row(
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
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.delete_outline)),
            IconButton(
              icon: AnimatedContainer(
                duration: const Duration(
                    milliseconds:
                        200), // Duração da animação (pode ajustar conforme necessário)
                decoration: BoxDecoration(
                  color: element.enable ? Colors.green.withOpacity(0.5) : null,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  element.enable
                      ? Icons.power_settings_new
                      : Icons.power_settings_new_outlined,
                  color: element.stats ? Colors.green : null,
                ),
              ),
              onPressed: () async {
                // await firebaseService.setElement(widget.blockName, element.room,
                //     element.name, element.type, element.pin, !element.enable);
              },
              tooltip: element.enable
                  ? 'Turn Off'
                  : 'Turn On', // Tooltip a ser exibida
            ),
          ],
        ),
        children: <Widget>[
          FutureBuilder(
            future: getActuatorsByAttachPins(actuators, element.attachPins),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map<String, String>> obj =
                    snapshot.data as List<Map<String, String>>;
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
                    itemCount: obj.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.001,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      String name = obj[index]['name']!;
                      String type = obj[index]['type']!;
                      String pin = obj[index]['pin']!;
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
                                      name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    Text(
                                      "Type: $type   Pin: $pin",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete_outline)),
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
          Card(
              margin: const EdgeInsets.all(4.0),
              color: Colors.transparent,
              child: TextButton(
                onPressed: () {
                  elementAttach(context, widget.token, widget.block.blockId,
                      element, actuators);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 155, 182, 178)), // Cor de fundo
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.all(16.0)), // Preenchimento
                ),
                child: const Text("New Attach"),
              )),
        ],
      ),
    );
  }
}

Widget buildcardRooms(BuildContext context, String item) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: <Widget>[
          Text(
            item,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline)),
        ],
      ),
    ),
  );
}

Widget buildcardRequest(BuildContext context, Request item) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: <Widget>[
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline)),
        ],
      ),
    ),
  );
}
