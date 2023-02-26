import 'package:flutter/material.dart';
import 'alerts_and_checks.dart';
import 'firebase_services.dart';

//TODO adicioar indicadores de aguardar resposta, alem de adicionar mensagens de possiveis erros

Future<void> blockCreate(BuildContext context) async {
  final FirebaseService firebaseService = FirebaseService();
  String blockName = "";
  final formKey = GlobalKey<FormState>();
  bool isDialogOpen = false;

  if (!isDialogOpen) {
    isDialogOpen = true;
    () => isDialogOpen = false;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a Block'),
          actions: <Widget>[
            Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Block Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a block name';
                        }
                        return null;
                      },
                      onSaved: (value) => blockName = value!,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          firebaseService.createBlock(blockName);
                          Navigator.pop(context);
                          dialogBox(context, 'Notification',
                              'The Block was created successfully');
                        }
                      },
                      child: const Text('send'),
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }
}

Future<void> roomCreate(BuildContext context) async {
  final FirebaseService firebaseService = FirebaseService();
  final item = await firebaseService.getBlocks();
  final formKey = GlobalKey<FormState>();
  String selectedBlock = item.isNotEmpty ? item[0] : "";
  String roomName = item.isNotEmpty ? item[0] : "";
  bool isDialogOpen = false;

  if (!isDialogOpen) {
    isDialogOpen = true;
    () => isDialogOpen = false;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (!item.isNotEmpty) {
              return wdialogBox(context, 'Notification',
                  'No Blocks were found, please create a block first');
            }
            return AlertDialog(
              title: const Text('Create a Room'),
              actions: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Room Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a room name';
                          }
                          return null;
                        },
                        onSaved: (value) => roomName = value!,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'block name',
                        ),
                        items:
                            item.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) => selectedBlock = value!,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a block';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            firebaseService.createRoom(selectedBlock, roomName);
                            Navigator.pop(context);
                            dialogBox(context, 'Notification',
                                'The room was created successfully');
                          }
                        },
                        child: const Text('send'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

List<String> itemStyle = [
  "Light",
  "Air-Conditioner",
  "Presence Sensor",
  "Current Sensor"
];
Future<void> elementCreate(BuildContext context) async {
  //TODO consertar error de quando muda o bloco crasha a aplicação pq a lista do dropbutton nao pode ser alterada.
  final FirebaseService firebaseService = FirebaseService();
  final blocks = await firebaseService.getBlocks();
  final formKey = GlobalKey<FormState>();
  String selectedBlock = blocks.isNotEmpty ? blocks[0] : "";
  final roomcheck = await firebaseService.getRooms(selectedBlock);
  List<String> rooms = [];
  String selectedRoom = rooms.isNotEmpty ? blocks[0] : "";
  String selectedElement = "";
  String elementName = "";
  String selectedPin = "";
  bool isDialogOpen = false;
  bool isUpdatingRooms = true;

  if (!isDialogOpen) {
    isDialogOpen = true;
    () => isDialogOpen = false;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          if (!blocks.isNotEmpty) {
            return wdialogBox(context, "Notification",
                "No Blocks were found, please create a block first");
          }
          if (!roomcheck.isNotEmpty) {
            return wdialogBox(context, "Notification",
                "No Rooms were found, please create a room first");
          }
          return AlertDialog(
            title: const Text('Create a Room'),
            actions: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Element Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Element name';
                        }
                        return null;
                      },
                      onSaved: (value) => elementName = value!,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    //---------------------Element type
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Element Type',
                      ),
                      items: itemStyle
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => selectedElement = value!,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a Element Type';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    //---------------------Element pin
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Element Pin',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Element Pin';
                        }
                        if (!isInt(value)) {
                          return 'Please enter a number';
                        }
                        return null;
                      },
                      onSaved: (value) => selectedPin = value!,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
//---------------------Block
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'block name',
                      ),
                      items:
                          blocks.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBlock = value!;
                          selectedRoom = "";
                          rooms = [];
                          isUpdatingRooms = true;
                        });
                        firebaseService.getRooms(selectedBlock).then((value) {
                          setState(() {
                            rooms = value;
                            isUpdatingRooms = false;
                          });
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a block';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
//---------------------Room
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Room name',
                      ),
                      items: isUpdatingRooms
                          ? []
                          : rooms.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      onChanged: isUpdatingRooms
                          ? null
                          : (value) => selectedRoom = value!,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a Room';
                        }
                        return null;
                      },
                      onTap: () {
                        if (isUpdatingRooms) {
                          return null;
                        }
                      },
                      disabledHint: Text('Loading rooms...'),
                      dropdownColor: isUpdatingRooms ? Colors.grey[300] : null,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          firebaseService.createElement(
                              selectedBlock,
                              selectedRoom,
                              elementName,
                              selectedElement,
                              int.parse(selectedPin));
                          Navigator.pop(context);
                          dialogBox(context, 'Notification',
                              'The Element was created successfully');
                        }
                      },
                      child: const Text('send'),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
