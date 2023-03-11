import 'package:flutter/material.dart';

class RoomPage extends StatelessWidget {
  final String roomName;

  const RoomPage({required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(roomName),
      ),
      body: Center(
        child: Text('This is the $roomName room.'),
      ),
    );
  }
}
