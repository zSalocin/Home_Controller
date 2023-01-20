
import 'package:flutter/material.dart';

import 'FireBase_Services.dart';

Future<void> blockCreate(BuildContext context) {
  final FirebaseService firebaseService = FirebaseService();
  String? blockName;
  final formKey = GlobalKey<FormState>();
  bool isDialogOpen = false;

  if(!isDialogOpen) {
    isDialogOpen = true;
        () => isDialogOpen = false;
    return showDialog<void>(
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
                      width: MediaQuery.of(context).size.width*0.01,
                      height: MediaQuery.of(context).size.height*0.01,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          firebaseService.createBlock(blockName!);
                          Navigator.pop(context);
                          dialogBox(context,'Notification','The Block was created successfully');
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
  }}


Future<void> roomCreate(BuildContext context) async {
  final FirebaseService firebaseService = FirebaseService();
  final item = await firebaseService.getBlocks();
  final formKey = GlobalKey<FormState>();
  String selectedBuilding = item.isNotEmpty ? item[0] : "";
  String roomName = item.isNotEmpty ? item[0] : "";
  bool isDialogOpen = false;

  if(!isDialogOpen) {
    isDialogOpen = true;
        () => isDialogOpen = false;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                        width: MediaQuery.of(context).size.width*0.01,
                        height: MediaQuery.of(context).size.height*0.01,
                      ),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'block name',
                        ),
                        items: item.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) => selectedBuilding = value!,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a block';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.01,
                        height: MediaQuery.of(context).size.height*0.01,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedBuilding != "" ) {
                            firebaseService.createRoom(selectedBuilding, roomName);
                          }
                          if (roomName != "" ) {
                            firebaseService.createRoom(selectedBuilding, roomName);
                          }
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            firebaseService.createRoom(selectedBuilding, roomName);
                            Navigator.pop(context);
                            dialogBox(context,'Notification','The room was created successfully');
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

void dialogBox(BuildContext context,String tittle,String text) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(tittle),
        content:
        Text(text),
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


Future<void> elementCreate(BuildContext context) async {
  final FirebaseService firebaseService = FirebaseService();
  final blocks = await firebaseService.getBlocks();
  final formKey = GlobalKey<FormState>();
  String selectedBlock = blocks.isNotEmpty ? blocks[0] : "";
  final rooms = await firebaseService.getRooms(selectedBlock);
  String selectedRoom = blocks.isNotEmpty ? blocks[0] : "";
  String elementName = blocks.isNotEmpty ? blocks[0] : "";
  bool isDialogOpen = false;

  if(!isDialogOpen) {
    isDialogOpen = true;
        () => isDialogOpen = false;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                        width: MediaQuery.of(context).size.width*0.01,
                        height: MediaQuery.of(context).size.height*0.01,
                      ),
                      //---------------------Element type
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Room name',
                        ),
                        items: rooms.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) => selectedBlock = value!,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a Room';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.01,
                        height: MediaQuery.of(context).size.height*0.01,
                      ),
                      //---------------------Element pin
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
            width: MediaQuery.of(context).size.width*0.01,
            height: MediaQuery.of(context).size.height*0.01,),
                      //---------------------Block
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'block name',
                        ),
                        items: blocks.map<DropdownMenuItem<String>>((String value) {
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
                        width: MediaQuery.of(context).size.width*0.01,
                        height: MediaQuery.of(context).size.height*0.01,
                      ),
                      //---------------------Room
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Room name',
                        ),
                        items: rooms.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) => selectedBlock = value!,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a Room';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.01,
                        height: MediaQuery.of(context).size.height*0.01,
                      ),
                      ElevatedButton(
                        onPressed: () async {

                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            //TODO element create
                            Navigator.pop(context);
                            dialogBox(context,'Notification','The room was created successfully');
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