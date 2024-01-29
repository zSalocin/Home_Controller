class Block {
  String userId;
  String name;
  List<Element> elements;
  List<Request> requests;
  List<Room> rooms;
  List<int> sensors;

  Block({
    required this.userId,
    required this.name,
    required this.elements,
    required this.requests,
    required this.rooms,
    required this.sensors,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      userId: json['userId'],
      name: json['name'],
      elements: List<Element>.from(
          json['element'].map((element) => Element.fromJson(element))),
      requests: List<Request>.from(
          json['requests'].map((request) => Request.fromJson(request))),
      rooms: List<Room>.from(json['room'].map((room) => Room.fromJson(room))),
      sensors: List<int>.from(json['sensor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'element': elements.map((element) => element.toJson()).toList(),
      'requests': requests.map((request) => request.toJson()).toList(),
      'room': rooms.map((room) => room.toJson()).toList(),
      'sensor': sensors,
    };
  }
}

class Element {
  bool enable;
  bool stats;
  int pin;
  String elementName;
  String elementRoom;
  String elementType;
  List<int> attachPins;

  Element({
    required this.enable,
    required this.stats,
    required this.pin,
    required this.elementName,
    required this.elementRoom,
    required this.elementType,
    required this.attachPins,
  });

  factory Element.fromJson(Map<String, dynamic> json) {
    return Element(
      enable: json['enable'],
      stats: json['stats'],
      pin: json['pin'],
      elementName: json['elementName'],
      elementRoom: json['elementRoom'],
      elementType: json['elementType'],
      attachPins: List<int>.from(json['attachPins']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
  int pin;
  bool stats;

  Request({
    required this.name,
    required this.pin,
    required this.stats,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      name: json['name'],
      pin: json['pin'],
      stats: json['stats'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
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
