import 'package:firebase_database/firebase_database.dart';

//TODO adicionar try catch aos metodos para evitar error

class FirebaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<List<String>> getBlocks() async {
    final blocks = <String>[];
    final buildingsRef = _database.ref().child("Blocos");
    buildingsRef.onValue.listen((event) {
      event.snapshot.children.map((child) {
        if (child.key != null) {
          blocks.add(child.key.toString());
        }
      }).toList();
    });
    return blocks;
  }

  Future<List<String>> getRooms(String block) async {
    final buildings = <String>[];
    final buildingsRef = _database.ref().child("/Blocos/$block/rooms/");
    buildingsRef.onValue.listen((event) {
      event.snapshot.children.map((child) {
        if (child.key != null) {
          buildings.add(child.key.toString());
        }
      }).toList();
    });
    return buildings;
  }

  Future<void> createBlock(String blockName) async {
    final block = <String, dynamic>{
      'name': blockName,
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
      'name': roomName,
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
      'name': elementName,
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
    _database.ref().child('/Blocos/$blockName/$elementName').update(updates);
  }

  Future<void> deleteElement(String blockName, String elementName) async {
    await _database.ref().child('/Blocos/$blockName/$elementName').remove();
  }
}
