class Block {
  final String name;
  final bool luz;

  Block({required this.name, required this.luz});

  factory Block.fromRTDB(Map<dynamic, dynamic> data) {
    return Block(
      name: data['name'] ?? 'Bloco misterioso',
      luz: data['luz'] ?? false,
    );
  }
}

class Room {
  final String name;
  final bool luz;
  final bool air;

  Room({required this.name, required this.luz, required this.air});

  factory Room.fromRTDB(Map<dynamic, dynamic> data) {
    return Room(
      name: data['name'] ?? 'sala secreta',
      luz: data['luz'] ?? false,
      air: data['air'] ?? false,
    );
  }
}

class Obj {
  final String name;
  final String room;
  final String type;
  final bool stats;
  final int pin;

  Obj({
    required this.name,
    required this.type,
    required this.room,
    required this.stats,
    required this.pin,
  });

  factory Obj.fromRTDB(Map<dynamic, dynamic> data) {
    return Obj(
      name: data['name'] ?? 'nome oculto',
      pin: data['pin'] ?? 0,
      room: data['room'] ?? 'sala secreta',
      stats: data['stats'] ?? false,
      type: data['type'] ?? 'typo indefinido',
    );
  }
}
