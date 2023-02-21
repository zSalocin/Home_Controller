class Bloco {
  final String name;
  final bool luz;

  Bloco({required this.name, required this.luz});

  factory Bloco.fromRTDB(Map<dynamic, dynamic> data) {
    return Bloco(
      name: data['name'] ?? 'Bloco misterioso',
      luz: data['luz'] ?? false,
    );
  }
}

class Sala {
  final String name;
  final bool luz;
  final bool air;

  Sala({required this.name, required this.luz, required this.air});

  factory Sala.fromRTDB(Map<dynamic, dynamic> data) {
    return Sala(
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
