import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

// Pins Methods

  Future<List<int>> getDigitalPins(String blockName) async {
    try {
      final snapshot =
          await _database.ref().child('/Blocos/$blockName/Config').once();
      final config = snapshot.snapshot.value as Map<String, dynamic>;

      if (config.containsKey('ControllerDigitalPins')) {
        final digitalPins = config['ControllerDigitalPins'] as List<dynamic>;
        return List<int>.from(digitalPins);
      } else {
        return [-1]; // Return an empty list if the key is not present
      }
    } catch (e) {
      return [-1];
    }
  }

  Future<List<int>> getAnalogPins(String blockName) async {
    try {
      final snapshot =
          await _database.ref().child('/Blocos/$blockName/Config').once();
      final config = snapshot.snapshot.value as Map<String, dynamic>;

      if (config.containsKey('ControllerAnalogPins')) {
        final analogPins = config['ControllerAnalogPins'] as List<dynamic>;
        return List<int>.from(analogPins);
      } else {
        return [-1]; // Return an empty list if the key is not present
      }
    } catch (e) {
      return [-1];
    }
  }

// Block Methods

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

  Future<String> setBlock(String blockName) async {
    final block = <String, dynamic>{
      'name': blockName,
    };
    final config = <String, dynamic>{
      'name': blockName,
      'ControllerNamer': "none",
      'ControllerType': "none",
      'ControllerDigitalPins': [
        1,
        2,
        3,
        4,
        5
      ], //TODO THIS SHOUD BE REMOVE LATER
      'ControllerAnalogPins:': [],
    };
    if (await blockCheck(blockName)) {
      return "The Block $blockName was not create sucessfully due a block with the same name already exist";
    } else {
      try {
        await _database.ref().child('/Blocos/$blockName').update(block);
        await _database.ref().child('/Blocos/$blockName/Config').update(config);
        return "The Block $blockName was created successfully";
      } catch (e) {
        return "The Block $blockName was not created successfully due $e";
      }
    }
  }

  Future<String> updateBlock(
      String blockName, Map<String, dynamic> updates) async {
    try {
      _database.ref().child('/Blocos/$blockName').update(updates);
      return "The Block $blockName was updated successfully";
    } catch (e) {
      return "The Block $blockName was not updated successfully due $e";
    }
  }

  Future<String> removeBlock(String blockName) async {
    try {
      await _database.ref().child('/Blocos/$blockName').remove();
      return "The Block $blockName was removed successfully";
    } catch (e) {
      return "The Block $blockName was not removed successfully due $e";
    }
  }

// Rooms Methods

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

  Future<String> setRoom(String blockName, String roomName) async {
    final room = <String, dynamic>{
      'name': roomName,
    };
    if (await roomCheck(roomName, blockName)) {
      return "The Room $roomName was not create sucessfully due a room with the same name already exist";
    } else {
      try {
        await _database
            .ref()
            .child('/Blocos/$blockName/rooms/$roomName')
            .update(room);
        return "The Room $roomName was created successfully";
      } catch (e) {
        return "The Room $roomName was not created successfully due $e";
      }
    }
  }

  Future<String> updateRoom(
      String block, String roomName, Map<String, dynamic> updates) async {
    try {
      _database.ref().child('/Blocos/$block/rooms/$roomName').update(updates);
      return "The Room $roomName was created successfully";
    } catch (e) {
      return "The Room $roomName was not created successfully due $e";
    }
  }

  Future<String> removeRoom(String block, String roomName) async {
    try {
      await _database.ref().child('/Blocos/$block/rooms/$roomName').remove();
      return "The Room $roomName was removed successfully";
    } catch (e) {
      return "The Room $roomName was not removed successfully due $e";
    }
  }

// Elements Methods

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

  Future<String> setElement(
    String blockName,
    String roomName,
    String elementName,
    String type,
    int pin,
    bool enableStats,
  ) async {
    final element = <String, dynamic>{
      'room': roomName,
      'name': elementName,
      'type': type,
      'pin': pin,
      'enable': enableStats,
      'stats': false,
    };
    final elementExists = await elementCheck(elementName, blockName);
    if (elementExists) {
      return "The Element $elementName was not create sucessfully due a element with the same name already exist";
    } else {
      final digitalPins = await getDigitalPins(blockName);
      //         -----------------------------------------------------------------------see later
      // ignore: unnecessary_null_comparison
      if (digitalPins == null) {
        return "Please Connect a ESP to the block for set the avalaible pins";
      } else {
        if (await pinCheck(blockName, pin, digitalPins)) {
          return "The Element $elementName was not create sucessfully due a element with the same pin already exist";
        } else {
          try {
            await _database
                .ref()
                .child('/Blocos/$blockName/Elements/$elementName')
                .update(element);
            return "The Element $elementName was created successfully";
          } catch (e) {
            return "The Element $elementName was not created successfully due $e";
          }
        }
      }
    }
  }

  Future<String> updateElement(String blockName, String elementName,
      Map<String, dynamic> updates) async {
    try {
      _database
          .ref()
          .child('/Blocos/$blockName/Elements/$elementName')
          .update(updates);
      return "The Element $elementName was updated successfully";
    } catch (e) {
      return "The Element $elementName was not updated successfully due $e";
    }
  }

  Future<String> removeElement(String blockName, String elementName) async {
    try {
      await _database
          .ref()
          .child('/Blocos/$blockName/Elements/$elementName')
          .remove();
      return "The Element $elementName was removed successfully";
    } catch (e) {
      return "The Element $elementName was not removed successfully due $e";
    }
  }

  // Request Methods

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

  Future<String> setRequest(
      String blockName, String elementName, int pin, bool state) async {
    final resquest = <String, dynamic>{
      'name': elementName,
      'pin': pin,
      'stats': state,
    };
    try {
      await _database
          .ref()
          .child('/Blocos/$blockName/Request/$elementName')
          .update(resquest);
      return "The Request for $elementName was created successfully";
    } catch (e) {
      return "The Request for $elementName was not created successfully due $e";
    }
  }

  Future<String> removeRequest(String blockName, String elementName) async {
    try {
      await _database
          .ref()
          .child('/Blocos/$blockName/Request/$elementName')
          .remove();
      return "The Request for $elementName was removed successfully";
    } catch (e) {
      return "The Request for $elementName was not removed successfully due $e";
    }
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
      return [-1];
    }
    return elementPins;
  }

// Attach pins in Sensors

  Future<void> setAttach(
      String blockName, elementName, int pin, List<int> attachPins) async {
    final attach = <String, dynamic>{
      'name': elementName,
      'pin': pin,
      'connectpins': attachPins,
    };

    await _database
        .ref()
        .child('/Blocos/$blockName/Sensors/$elementName')
        .update(attach);
  }
}

// Verify Methods

Future<bool> pinCheck(String blockName, int pin, List<int> permitedPins) async {
  FirebaseService firebaseService = FirebaseService();
  final elementPins = await firebaseService.getElementPins(blockName);
  if (permitedPins.contains(pin) && !elementPins.contains(pin)) {
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
  return item.contains(blockName);
}

Future<bool> roomCheck(String roomName, String blockName) async {
  final FirebaseService firebaseService = FirebaseService();
  final item = await firebaseService.getRooms(blockName);
  return item.contains(roomName);
}

Future<bool> elementCheck(String elementName, String blockName) async {
  final FirebaseService firebaseService = FirebaseService();
  final item = await firebaseService.getElement(blockName);
  return item.contains(elementName);
}



//Adicionar retornos com mensagens de erros se possivel.

//Corrigir problema de quando so há numeros como nome de um bloco, sala ou elemento ele da erro na leitura
