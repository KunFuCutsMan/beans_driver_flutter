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
  bool _isListo = false;
  
  @override
  void initState() {
    super.initState();

    if ( widget.rolUsuarioID == 1 ) {
      usu = Cliente(usuarioID: widget.usuarioID);
    }
    else if ( widget.rolUsuarioID == 2 ) {
      usu = Taxista(usuarioID: widget.usuarioID);
    }

    () async {
      await usu.obtenUsuarioEnDB();
      setState(() { _isListo = true; });
    }();
    
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isListo
        ? const TargetaServicio(servicioID: 2)
        : const Text("El legendario pantalla_home"),
    );
  }
}