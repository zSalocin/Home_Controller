class Bloco{
  final String name;

  Bloco({required this.name});

  factory Bloco.fromRTDB(Map<dynamic,dynamic> data){
    return Bloco(
      name:  data['name'] ?? 'Bloco misterioso',
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