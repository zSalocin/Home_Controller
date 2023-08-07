import 'package:flutter/material.dart';

//TODO in the future this interface page is to administer the users of program and permissions

class UserConfig extends StatefulWidget {
  const UserConfig({super.key});

  @override
  UserConfigState createState() => UserConfigState();
}

class UserConfigState extends State<UserConfig> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Config"),
        ),
        body: const Center(
          child: Text("Not done yet"),
        ));
  }
}
//Fazer layout resposivel