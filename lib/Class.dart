class Bloco{
  final String name;
  final bool luz;

  Bloco({required this.name,required this.luz});

  factory Bloco.fromRTDB(Map<dynamic,dynamic> data){
    return Bloco(
      name:  data['name'] ?? 'Bloco misterioso',
      luz: data['luz'] ?? false,
    );
  }
}

class Sala{
  final String name;
  final bool luz;
  final bool air;

  Sala({required this.name,required this.luz, required this.air});

  factory Sala.fromRTDB(Map<dynamic,dynamic> data){
    return Sala(
      name:  data['name'] ?? 'sala secreta',
      luz: data['luz'] ?? false,
      air: data['air'] ?? false,
    );
  }
}

class Element{
  final String name;
  final String icon;
  final bool stats;
  final int pin;

  Element({required this.name,required this.icon, required this.stats, required this.pin});

  factory Element.fromRTDB(Map<dynamic,dynamic> data){
    return Element(
      name:  data['name'] ?? 'sala secreta',
      icon: data['type'] ?? 'trocar por icone depois',
      stats: data['stats'] ?? false,
      pin: data['pin'] ?? 0,
    );
  }

}