import 'package:beans_driver_flutter/src/comun/targeta_servicio.dart';
import 'package:beans_driver_flutter/src/modelos/cliente.dart';
import 'package:beans_driver_flutter/src/modelos/taxista.dart';
import 'package:beans_driver_flutter/src/modelos/usuario.dart';
import 'package:flutter/material.dart';

class PantallaHome extends StatefulWidget {
  final int usuarioID;
  final int rolUsuarioID;
  const PantallaHome({super.key, required this.usuarioID, required this.rolUsuarioID});

  @override
  State<PantallaHome> createState() => _PantallaHomeState();
}

class _PantallaHomeState extends State<PantallaHome> {

  late final Usuario usu;
  late VeTargetaComo vista;
  bool _isListo = false;
  int servicioID = 0;
  
  @override
  void initState() {
    super.initState();

    if ( widget.rolUsuarioID == 1 ) {
      usu = Cliente(usuarioID: widget.usuarioID);
      vista = VeTargetaComo.cliente;
    }
    else if ( widget.rolUsuarioID == 2 ) {
      usu = Taxista(usuarioID: widget.usuarioID);
      vista = VeTargetaComo.taxista;
    }

    () async {
      await usu.obtenUsuarioEnDB();
      setState(() { _isListo = true; });
    }();
    
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isListo && servicioID > 0
        ? TargetaServicio(servicioID: servicioID, vista: vista)
        : const Text("El legendario pantalla_home"),
    );
  }
}