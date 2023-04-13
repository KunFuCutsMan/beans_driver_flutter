import 'package:flutter/material.dart';

class TabDatosPersona extends StatefulWidget {
  const TabDatosPersona({super.key});

  @override
  State<TabDatosPersona> createState() => _TabDatosPersonaState();
}

class _TabDatosPersonaState extends State<TabDatosPersona> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Text("Datos personales"),
          Text("Lorem ipsum"),
        ],
      ),
    );
  }
}