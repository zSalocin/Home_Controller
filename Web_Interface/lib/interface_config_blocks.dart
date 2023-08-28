import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'firebase_call.dart';
import 'firebase_services.dart';
import 'class.dart';
import 'components.dart';

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
                                    child: controlButtons(context),
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
                                      child: controlButtons(context),
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
                                child: eelementCreateDialogBox(
                              context,
                              'No Elements Found',
                              'Please add a Element',
                              widget.blockName,
                            ));
                          } else {
                            List<Obj> sensors = [];
                            List<Obj> actuators = [];

                            for (var elementMap in item) {
                              Obj element = Obj.fromRTDB(elementMap);
                              bool isSensor =
                                  element.type.toLowerCase().contains('sensor');
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
                                  buildCardSensor(context, sensor),
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
                          }
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
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
                    element.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    element.type,
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
                await firebaseService.createElement(
                    widget.blockName,
                    element.room,
                    element.name,
                    element.type,
                    element.pin,
                    !element.enable);
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

  Widget buildCardSensor(BuildContext context, Obj element) {
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
                    element.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    element.type,
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
                await firebaseService.createElement(
                    widget.blockName,
                    element.room,
                    element.name,
                    element.type,
                    element.pin,
                    !element.enable);
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

  Widget controlButtons(BuildContext context) {
    double buttonSize = MediaQuery.of(context).size.height * 0.05;
    return Column(
      children: [
        ElevatedButton(
          onPressed: null,
          child: Text("New"),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.lightbulb_circle),
                  iconSize: buttonSize,
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.lightbulb_circle_outlined),
                  iconSize: buttonSize,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.lightbulb_circle),
                  iconSize: buttonSize,
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.lightbulb_circle_outlined),
                  iconSize: buttonSize,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.lightbulb_circle),
                  iconSize: buttonSize,
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.lightbulb_circle_outlined),
                  iconSize: buttonSize,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


//Fazer layout resposivel