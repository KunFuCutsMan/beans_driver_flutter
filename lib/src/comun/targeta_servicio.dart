import 'dart:developer';

import 'package:beans_driver_flutter/src/modelos/servicio.dart';
import 'package:flutter/material.dart';

class TargetaServicio extends StatefulWidget {
  final int servicioID;
  const TargetaServicio({super.key, required this.servicioID});

  @override
  State<TargetaServicio> createState() => _TargetaServicioState();
}

class _TargetaServicioState extends State<TargetaServicio> {

  late final Servicio serv;
  bool _isListo = false;

  @override
  void initState() {
    super.initState();
    serv = Servicio(servicioID: widget.servicioID);

    () async {
      await serv.obtenServicioEnDB();
      log("Listo");
      setState(() { _isListo = true; });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      margin: const EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Row(
            children: [
              Text(_isListo ? "${serv.statusServicioID}" : " "),
              Text(_isListo ? "${serv.fecha}" : " "),
              Text(_isListo ? "${serv.hora}" : " "),
            ],
          ),
        ],
      ),
    );
  }
}