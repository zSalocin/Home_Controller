class Block {
  String blockId;
  String userId;
  String name;
  int roomNumber;
  int elementNumber;

  Block({
    required this.blockId,
    required this.userId,
    required this.name,
    required this.roomNumber,
    required this.elementNumber,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      blockId: json['_id'],
      userId: json['userId'],
      name: json['name'],
      roomNumber: json['roomNumber'] != null ? json['roomNumber'] as int : 0,
      elementNumber:
          json['elementNumber'] != null ? json['roomNumber'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blockId': blockId,
      'userId': userId,
      'name': name,
      'roomNumber': roomNumber,
      'elementNumber': elementNumber,
    };
  }
}

class Obj {
  String id;
  bool enable;
  bool stats;
  int pin;
  String elementName;
  String elementRoom;
  String elementType;
  List<int> attachPins;

  Obj({
    required this.id,
    required this.enable,
    required this.stats,
    required this.pin,
    required this.elementName,
    required this.elementRoom,
    required this.elementType,
    required this.attachPins,
  });

  factory Obj.fromJson(Map<String, dynamic> json) {
    return Obj(
      id: json['_id'],
      enable: json['enable'],
      stats: json['stats'],
      pin: json['pin'],
      elementName: json['elementName'],
      elementRoom: json['elementRoom'],
      elementType: json['elementType'],
      attachPins: List<int>.from(json['attachPins'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enable': enable,
      'stats': stats,
      'pin': pin,
      'elementName': elementName,
      'elementRoom': elementRoom,
      'elementType': elementType,
      'attachPins': attachPins,
    };
  }
}

class Request {
  String name;
  String time;
  int pin;
  bool stats;

  Request({
    required this.name,
    required this.time,
    required this.pin,
    required this.stats,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      name: json['name'],
      time: json['time'],
      pin: json['pin'],
      stats: json['stats'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'time': time,
      'pin': pin,
      'stats': stats,
    };
  }
}

class Room {
  String roomName;

  Room({
    required this.roomName,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomName: json['roomName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomName': roomName,
    };
  }
}
