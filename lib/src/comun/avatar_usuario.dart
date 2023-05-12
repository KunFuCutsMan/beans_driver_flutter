import 'package:avatars/avatars.dart';
import 'package:beans_driver_flutter/src/comun/dialogo_edita_avatar.dart';
import 'package:beans_driver_flutter/src/modelos/persona.dart';
import 'package:beans_driver_flutter/src/modelos/usuario.dart';
import 'package:flutter/material.dart';

class AvatarUsuario extends StatelessWidget {

  final Usuario usu;
  final Persona per;
  final bool permiteEditar;

  const AvatarUsuario({super.key, required this.usu, required this.per, required this.permiteEditar});

  @override
  Widget build(BuildContext context) {
    return Avatar(
      name: "${per.nombre} ${per.apePrimero} ${per.apeSegundo}",

      sources: [
        NetworkSource( "http://10.0.2.2/beans-driver-backend/usuario/avatar/?usuarioID=${usu.usuarioID}" )
      ],
      
      shape: AvatarShape.circle(100),

      onTap: permiteEditar
        ? () => DialogoEditaAvatar.avisaEdita(context)
        : null,
      
    );
  }
}