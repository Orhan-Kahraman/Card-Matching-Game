import 'package:flutter/material.dart';

class GameScreenMulti extends StatelessWidget {
  const GameScreenMulti({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(
          child: Center(
        child: Text("ÇOKLU OYUN EKRANINA HOŞGELDİNİZ"),
      )),
    );
  }
}
