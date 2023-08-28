class Block {
  final String name;

  Block({required this.name});

  factory Block.fromRTDB(Map<dynamic, dynamic> data) {
    return Block(
      name: data['name'] ?? 'Bloco misterioso',
    );
  }
}

class Room {
  final String name;

  Room({required this.name});

  factory Room.fromRTDB(Map<dynamic, dynamic> data) {
    return Room(
      name: data['name'] ?? 'sala secreta',
    );
  }
}

class Obj {
  final String name;
  final String room;
  final String type;
  final bool stats;
  final int pin;
  bool enable;

  Obj({
    required this.name,
    required this.type,
    required this.room,
    required this.stats,
    required this.pin,
    required this.enable,
  });

  factory Obj.fromRTDB(Map<dynamic, dynamic> data) {
    return Obj(
      name: data['name'] ?? 'nome oculto',
      pin: data['pin'] ?? 0,
      room: data['room'] ?? 'sala secreta',
      type: data['type'] ?? 'typo indefinido',
      enable: data['enable'] ?? false,
      stats: data['stats'] ?? false,
    );
  }
}

class Request {
  final String name;
  final int pin;
  final bool state;

  Request({required this.name, required this.pin, required this.state});

  factory Request.fromRTDB(Map<dynamic, dynamic> data) {
    return Request(
      name: data['name'] ?? 'unnow name',
      pin: data['pin'] ?? 0,
      state: data['state'] ?? false,
    );
  }
}
