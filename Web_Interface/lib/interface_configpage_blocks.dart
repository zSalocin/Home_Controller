import 'package:flutter/material.dart';
import 'package:tcc_2023/backend_services.dart';
import 'class.dart';
import 'components.dart';

class BlockConfig extends StatefulWidget {
  final String blockId;
  final String token;

  const BlockConfig({super.key, required this.blockId, required this.token});

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
      body: Row(
        children: [
          Expanded(
            flex: 60,
            child: Column(
              children: [
                Expanded(
                  flex: 60,
                  child: Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 30,
                          child: Container(
                            alignment: Alignment.center,
                            color: const Color.fromARGB(
                                255, 148, 121, 121), //cor de fundo geral
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 80,
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.red,
                                    child: const Text("Future Rooms Info"),
                                  ),
                                ),
                                Expanded(
                                  flex: 20,
                                  child: Container(
                                    margin: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.005),
                                    alignment: Alignment.center,
                                    color: const Color.fromARGB(
                                        255, 148, 121, 121),
                                    child: Container(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 30,
                          child: Container(
                            alignment: Alignment.center,
                            color: const Color.fromARGB(
                                255, 148, 121, 121), //fundo dos botoes
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 80,
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.red,
                                    child: const Text("Future Elements Info"),
                                  ),
                                ),
                                Expanded(
                                  flex: 20,
                                  child: Container(
                                    margin: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.005),
                                    alignment: Alignment.center,
                                    color: const Color.fromARGB(
                                        255, 148, 121, 121),
                                    child: Expanded(
                                      child: Container(
                                        color: Colors.black,
                                      ),
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
                ),
                Expanded(
                  flex: 40,
                  child: Container(
                    color: Colors.green,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 40,
                          child: Image.asset(
                            'assets/background_image.jpg', // Replace with your image path
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Expanded(
                          flex: 30,
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.amber,
                            child: const Text("Future Avaliable Pins"),
                          ),
                        ),
                        Expanded(
                          flex: 30,
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.pink,
                            child: const Text("Future Requests"),
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
                    color: Colors.blue,
                    alignment: Alignment.centerRight,
                    child: FutureBuilder(
                      future: getElements(widget.token, widget.blockId),
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
                                  selectedBlock: widget.blockId,
                                );
                              },
                              child: const Text("Create a Button"),
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
                                      type,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
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
          Card(
            margin: const EdgeInsets.all(0),
            color: Colors.transparent,
            child: TextButton(
              onPressed: () {
                elementAttach(
                    context, widget.token, widget.blockId, element, actuators);
              },
              child: const Text("New Attach"),
            ),
          ),
        ],
      ),
    );
  }
}
