import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Class.dart';

class Salas extends StatefulWidget {
  final String text;

  Salas({Key? key, required this.text}) : super(key: key);


  @override
  _SalaState createState() => _SalaState();
}

class _SalaState extends State<Salas> {
  final _database = FirebaseDatabase.instance.ref();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Salas ${widget.text} Command Page'),
      ),
      body: Container(
          color: Colors.blue,
          child: StreamBuilder(
              stream: _database.child('Blocos/${widget.text}/Salas').onValue,
              builder: (context,snapshot){
                List item = [];
                if(snapshot.hasData){
                  Map<dynamic, dynamic> data = (snapshot.data! as dynamic).snapshot.value;
                  data.forEach((index, data) => item.add({'key': index,...data}));
                  return ListView.builder(
                    itemCount: item.length,
                    itemBuilder: (BuildContext context, int index) => buildCard(context, Sala.fromRTDB(item[index])),
                  );
                }else{
                  return const CircularProgressIndicator();
                }
              }
          )
      ),
    );
  }

  Widget buildCard(BuildContext context, Sala sala, ) {
    final blocA101 = _database.child('Blocos/${widget.text}/Salas/${sala.name}');
    return Card(
      color: Colors.grey,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            SizedBox(width: MediaQuery.of(context).size.width*0.01,),
            ElevatedButton(onPressed: (){}, child: Text(sala.name),),
            SizedBox(width: MediaQuery.of(context).size.width*0.01,),
            IconButton(onPressed: () async{
              if(sala.luz == true) {
                await blocA101.update({'luz':false});
              } else {
                await blocA101.update({'luz':true});
              }
            }, icon: sala.luz ? const Icon(Icons.lightbulb) : const Icon(Icons.lightbulb_outline)),
            SizedBox(width: MediaQuery.of(context).size.width*0.01,),
            IconButton(onPressed: () async{
              if(sala.air == true) {
                await blocA101.update({'air':false});
              } else {
                await blocA101.update({'air':true});
              }
            }, icon: sala.air ? const Icon(Icons.ac_unit) : const Icon(Icons.block)),
            SizedBox(width: MediaQuery.of(context).size.width*0.01,),
          ],
        ),
      ),
    );
  }
}
