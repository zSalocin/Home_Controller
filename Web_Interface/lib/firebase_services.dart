import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<List<String>> getBlocks() async {
    final blocks = <String>[];
    final blocksRef = _database.ref().child("Blocos");
    blocksRef.onValue.listen((event) {
      event.snapshot.children.map((child) {
        if (child.key != null) {
          blocks.add(child.key.toString());
        }
      }).toList();
    });
    return blocks;
  }

  Future<List<String>> getRooms(String blockName) async {
    final rooms = <String>[];
    final roomsRef = _database.ref().child("/Blocos/$blockName/rooms/");
    roomsRef.onValue.listen((event) {
      event.snapshot.children.map((child) {
        if (child.key != null) {
          rooms.add(child.key.toString());
        }
      }).toList();
    });
    return rooms;
  }

  Future<List<String>> getElement(String blockName) async {
    final element = <String>[];
    final elementRef = _database.ref().child("/Blocos/$blockName/Elements/");
    elementRef.onValue.listen((event) {
      event.snapshot.children.map((child) {
        if (child.key != null) {
          element.add(child.key.toString());
        }
      }).toList();
    });
    return element;
  }

  Future<List<String>> getElementforRoom(
      String blockName, String roomName) async {
    final element = <String>[];
    final elementRef = _database.ref().child("/Blocos/$blockName/Elements/");
    elementRef.onValue.listen((event) {
      event.snapshot.children.map((child) {
        if (child.key != null && child.child('room').value == roomName) {
          element.add(child.key.toString());
        }
      }).toList();
    });
    return element;
  }

  Future<List<String>> getRequest(String block) async {
    final request = <String>[];
    final requestRef = _database.ref().child("/Blocos/$block/Request/");
    requestRef.onValue.listen((event) {
      event.snapshot.children.map((child) {
        if (child.key != null) {
          request.add(child.key.toString());
        }
      }).toList();
    });
    return request;
  }

  Future<void> createBlock(String blockName) async {
    final block = <String, dynamic>{
      'name': 'Bloco $blockName',
    };
    try {
      await _database.ref().child('/Blocos/Bloco $blockName').update(block);
    } catch (e) {
      print('Error updating block: $e');
    }
  }

  Future<void> updateBlock(
      String blockName, Map<String, dynamic> updates) async {
    _database.ref().child('/Blocos/$blockName').update(updates);
  }

  Future<void> deleteBlock(String blockName) async {
    await _database.ref().child('/Blocos/$blockName').remove();
  }

  Future<void> createRoom(String block, String roomName) async {
    final room = <String, dynamic>{
      'name': 'Sala $roomName',
    };
    await _database
        .ref()
        .child('/Blocos/$block/rooms/Sala $roomName')
        .update(room);
  }

  Future<void> updateRoom(
      String block, String roomName, Map<String, dynamic> updates) async {
    _database.ref().child('/Blocos/$block/rooms/$roomName').update(updates);
  }

  Future<void> deleteRoom(String block, String roomName) async {
    await _database.ref().child('/Blocos/$block/rooms/$roomName').remove();
  }

  Future<void> createElement(String blockName, String roomName,
      String elementName, String type, int pin) async {
    final element = <String, dynamic>{
      'room': roomName,
      'name': 'Element $elementName',
      'type': type,
      'stats': false,
      'pin': pin,
    };
    await _database
        .ref()
        .child('/Blocos/$blockName/Elements/Element $elementName')
        .update(element);
  }

  Future<void> updateElement(String blockName, String elementName,
      Map<String, dynamic> updates) async {
    _database
        .ref()
        .child('/Blocos/$blockName/Elements/$elementName')
        .update(updates);
  }

  Future<void> deleteElement(String blockName, String elementName) async {
    await _database
        .ref()
        .child('/Blocos/$blockName/Elements/$elementName')
        .remove();
  }

  Future<void> createRequest(
      String blockName, String elementName, int pin, bool state) async {
    final resquest = <String, dynamic>{
      'name': elementName,
      'pin': pin,
      'stats': false,
    };
    await _database
        .ref()
        .child('/Blocos/$blockName/Request/$elementName')
        .update(resquest);
  }

  Future<void> deleteRequest(String blockName, String elementName) async {
    await _database
        .ref()
        .child('/Blocos/$blockName/Request/$elementName')
        .remove();
  }

  Future<List<int>> getElementPins(String blockName) async {
    final elementPins = <int>[];
    final elementRef = _database.ref().child("/Blocos/$blockName/Elements/");
    try {
      elementRef.onValue.listen((event) {
        final snapshot = event.snapshot;
        if (snapshot.value != null) {
          final children = snapshot.value as Map<dynamic, dynamic>;
          children.forEach((key, value) {
            final pin = value['pin'];
            if (pin != null) {
              elementPins.add(pin);
            }
          });
        }
      });
    } catch (e) {
      print('Error getting element pins: $e');
    }
    return elementPins;
  }
}

//Adicionar retornos com mensagens de erros se possivel.
