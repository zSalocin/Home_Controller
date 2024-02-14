import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tcc_2023/backend_services.dart';
import 'package:tcc_2023/class.dart';

bool isInt(String value) {
  try {
    int.parse(value);
    return true;
  } catch (e) {
    return false;
  }
}

// // Dialog Box Components

void dialogBox(BuildContext context, String tittle, String text) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(tittle),
        content: Text(text),
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

// Future<bool> dialogBoxAcceptOrDecline(
//     BuildContext context, String title, String text) async {
//   bool? result = await showDialog<bool>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text(title),
//         content: Text(text),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context, true);
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.green,
//               textStyle: const TextStyle(fontSize: 18),
//             ),
//             child: const Text('Accept'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context, false);
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.red,
//               textStyle: const TextStyle(fontSize: 18),
//             ),
//             child: const Text('Decline'),
//           ),
//         ],
//       );
//     },
//   );
//   return result ?? false;
// }

Widget wdialogBox(BuildContext context, String tittle, String text) {
  return AlertDialog(
    title: Text(tittle),
    content: Text(text),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('OK'),
      ),
    ],
  );
}

Widget blockCreateDialogBox(
    BuildContext context, String token, String tittle, String text) {
  return AlertDialog(
      title: Text(tittle),
      content: Text(text),
      actions: <Widget>[
        Center(
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  blockCreate(context, token, () {});
                },
                child: const Text('Create a Block'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('close'),
              ),
            ],
          ),
        ),
      ]);
}

Widget roomCreateDialogBox(BuildContext context, String token, String blockname,
    String tittle, String text) {
  return AlertDialog(
      title: Text(tittle),
      content: Text(text),
      actions: <Widget>[
        Center(
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  roomCreate(
                    context: context,
                    token: token,
                    blockName: blockname,
                  );
                },
                child: const Text('Create a room'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('close'),
              ),
            ],
          ),
        ),
      ]);
}

Widget elementCreateDialogBox(BuildContext context, String token, String tittle,
    String text, String blockName, String roomName) {
  return AlertDialog(
      title: Text(tittle),
      content: Text(text),
      actions: <Widget>[
        Center(
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  elementCreate(
                      context: context,
                      token: token,
                      selectedBlock: blockName,
                      roomName: roomName);
                },
                child: const Text('Create a Element'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('close'),
              ),
            ],
          ),
        ),
      ]);
}

// // ---------------------------- Create Instances Database Components -----------------------------------------------------------------------------

//TODO Melhorar a janela de userRegister
Future<void> userRegister(BuildContext context) async {
  String userName = "";
  String passWord = "";
  final formKey = GlobalKey<FormState>();
  bool isDialogOpen = false;
  if (!isDialogOpen) {
    isDialogOpen = true;
    () => isDialogOpen = false;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New User'),
          actions: <Widget>[
            Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'user Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a user name';
                        }
                        return null;
                      },
                      onSaved: (value) => userName = value!,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'PassWord',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a PassWord';
                        }
                        return null;
                      },
                      onSaved: (value) => passWord = value!,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          Navigator.pop(context);
                          dialogBox(context, 'Notification',
                              await registerNewUser(userName, passWord));
                        }
                      },
                      child: const Text('create'),
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }
}

Future<void> blockCreate(
    BuildContext context, String token, Function() onComplete) async {
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
                          Navigator.pop(context);
                          dialogBox(context, 'Notification',
                              await addBlock(token, blockName));
                          onComplete();
                        }
                      },
                      child: const Text('create'),
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }
}

Future<void> roomCreate(
    {required BuildContext context,
    required String token,
    required String? blockName}) async {
  final item = await getBlocks(token);
  final formKey = GlobalKey<FormState>();
  String selectedBlock = "";
  String roomName = "";
  bool isDialogOpen = false;
  if (blockName != null) {
    selectedBlock = blockName;
  }
  if (!isDialogOpen) {
    isDialogOpen = true;
    () => isDialogOpen = false;
    // ignore: use_build_context_synchronously
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
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            Navigator.pop(context);
                            dialogBox(context, 'Notification',
                                await addRooms(token, selectedBlock, roomName));
                          }
                        },
                        child: const Text('create'),
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

// //TODO make the itemStyle List import from backend or esp
// //TODO Make the pins a dropdownButton import a list of valid pins for backend

Future<void> elementCreate(
    {required BuildContext context,
    required String token,
    required String selectedBlock,
    String? roomName}) async {
  final formKey = GlobalKey<FormState>();
  final roomcheck = await getRooms(token, selectedBlock);
  List<String> rooms = [];
  String selectedRoom = rooms.isNotEmpty ? rooms[0] : "";
  String selectedElement = "";
  String elementName = "";
  String selectedPin = "";
  bool isDialogOpen = false;
  if (roomName != null) {
    selectedRoom = roomName;
  }
  if (!isDialogOpen) {
    isDialogOpen = true;
    () => isDialogOpen = false;
    // ignore: use_build_context_synchronously
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          if (!roomcheck.isNotEmpty) {
            return wdialogBox(context, "Notification",
                "No Rooms were found, please create a room first");
          } else {
            rooms = roomcheck.cast<String>();
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
//---------------------Room
                    if (roomName == null) ...[
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Room name',
                        ),
                        items: rooms.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRoom = value!;
                          });
                        },
                        value: selectedRoom.isNotEmpty ? selectedRoom : null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a Room';
                          }
                          return null;
                        },
                        dropdownColor: Colors.grey[300],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    ],
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          Navigator.pop(context);
                          dialogBox(
                              context,
                              'Notification',
                              await addElement(
                                token: token,
                                blockId: selectedBlock,
                                roomName: selectedRoom,
                                elementName: elementName,
                                elementType: selectedElement,
                                pin: int.parse(selectedPin),
                                stats: false,
                                enable: true,
                              ));
                        }
                      },
                      child: const Text('create'),
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

Future<void> elementAttach(BuildContext context, String token, String blockId,
    Obj sensor, List<Obj> actuator) async {
  int attachpin = 0;
  final formKey = GlobalKey<FormState>();
  bool isDialogOpen = false;
  if (!isDialogOpen) {
    isDialogOpen = true;
    () => isDialogOpen = false;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attach a Actuator'),
          actions: <Widget>[
            Form(
                key: formKey,
                child: Column(
                  children: [
                    // add a dropdownbutton with the name of all actuators elements elements
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Attach Element',
                      ),
                      items:
                          actuator.map<DropdownMenuItem<Obj>>((Obj actuator) {
                        return DropdownMenuItem<Obj>(
                          value: actuator,
                          child: Text(actuator.elementName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        attachpin = (value as Obj).pin;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a Attach Element';
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
                        dialogBox(
                            context,
                            'Notification',
                            await addAttachtoElement(
                                token: token,
                                blockId: blockId,
                                elementId: sensor.id,
                                attachPin: attachpin));
                      },
                      child: const Text('create'),
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }
}

// //Adicionar menu flutuante para editar elemento e exluir