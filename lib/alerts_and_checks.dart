import 'dart:async';
import 'package:tcc_2023/firebase_call.dart';
import 'package:tcc_2023/firebase_services.dart';
import 'package:flutter/material.dart';

bool isInt(String value) {
  try {
    int.parse(value);
    return true;
  } catch (e) {
    return false;
  }
}

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

Future<bool> dialogBoxAcceptOrDecline(
    BuildContext context, String title, String text) async {
  bool? result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('Accept'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('Decline'),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

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

Widget blockCreateDialogBox(BuildContext context, String tittle, String text) {
  return AlertDialog(
      title: Text(tittle),
      content: Text(text),
      actions: <Widget>[
        Center(
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  blockCreate(context);
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

Widget elementCreateDialogBox(
    BuildContext context, String tittle, String text) {
  return AlertDialog(
      title: Text(tittle),
      content: Text(text),
      actions: <Widget>[
        Center(
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  elementCreate(context);
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

Future<bool> pinCheck(String blockName, String pin) async {
  final permitedPins = {1, 2, 3, 4, 5};
  FirebaseService firebaseService = FirebaseService();
  final elementPins = await firebaseService.getElementPins(blockName);
  final intPin = int.tryParse(pin);
  if (permitedPins.contains(intPin) && !elementPins.contains(intPin)) {
    return false;
  }
  return true;
}

Future<bool> requestCheck(String blockName, String elementName) async {
  final FirebaseService firebaseService = FirebaseService();
  final item = await firebaseService.getRequest(blockName);
  return item.contains(elementName);
}

Future<bool> blockCheck(String blockName) async {
  final FirebaseService firebaseService = FirebaseService();
  final item = await firebaseService.getBlocks();
  return item.contains('Bloco $blockName');
}

Future<bool> roomCheck(String roomName, String blockName) async {
  final FirebaseService firebaseService = FirebaseService();
  final item = await firebaseService.getRooms(blockName);
  return item.contains('Sala $roomName');
}

Future<bool> elementCheck(String elementName, String blockName) async {
  final FirebaseService firebaseService = FirebaseService();
  final item = await firebaseService.getElement(blockName);
  return item.contains('Element $elementName');
}
