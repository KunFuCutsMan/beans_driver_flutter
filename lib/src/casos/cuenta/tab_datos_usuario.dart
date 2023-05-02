import 'dart:developer';

import 'package:beans_driver_flutter/src/comun/dialogo_login.dart';
import 'package:flutter/material.dart';

class TabDatosUsuario extends StatefulWidget {
  const TabDatosUsuario({super.key});

  @override
  State<TabDatosUsuario> createState() => _TabDatosUsuarioState();
}

class _TabDatosUsuarioState extends State<TabDatosUsuario> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("Datos de usuario"),
          const Text( "Lorem ipsum"),
          ElevatedButton(
            onPressed: () => DialogoLogin.avisaLogin(context, () => log("Éxito")),
            child: const Text("validar"),
          ),
        ],
      ),
    );
  }
}