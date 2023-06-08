import 'package:beans_driver_flutter/src/comun/app_barra.dart';
import 'package:beans_driver_flutter/src/modelos/servicio.dart';
import 'package:flutter/material.dart';

class PantallaMapaServicio extends StatefulWidget {
  final int servicioID;
  const PantallaMapaServicio({super.key, required this.servicioID});

  @override
  State<PantallaMapaServicio> createState() => _PantallaMapaServicioState();
}

class _PantallaMapaServicioState extends State<PantallaMapaServicio> {

  late final Servicio serv;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarra(),
      body: Center(child: Text("${widget.servicioID}")),

      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton.small(
        child: const Icon(Icons.arrow_back),
        onPressed: (){}
      ),
    );
  }
}