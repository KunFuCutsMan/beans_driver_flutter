import 'package:flutter/material.dart';

class SegundaVista extends StatelessWidget {
  const SegundaVista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Beans Driver"))),
        body: const Center(child: Text("Esta es la vista para solicitar los servicios",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        textAlign: TextAlign.justify),
        ),
    );
  }
}
