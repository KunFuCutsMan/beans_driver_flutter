import 'package:flutter/material.dart';

class TabDatosUbicacion extends StatefulWidget {
  const TabDatosUbicacion({super.key});

  @override
  State<TabDatosUbicacion> createState() => _TabDatosUbicacionState();
}

class _TabDatosUbicacionState extends State<TabDatosUbicacion> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Text("Datos de ubicación"),
          Text("Lorem ipsum"),
        ],
      ),
    );
  }
}