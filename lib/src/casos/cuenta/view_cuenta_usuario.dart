import 'package:avatars/avatars.dart';
import 'package:beans_driver_flutter/src/casos/cuenta/tab_datos_persona.dart';
import 'package:beans_driver_flutter/src/casos/cuenta/tab_datos_ubicacion.dart';
import 'package:beans_driver_flutter/src/casos/cuenta/tab_datos_usuario.dart';
import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';

class ViewCuentaUsuario extends StatefulWidget {
  const ViewCuentaUsuario({super.key});

  @override
  State<ViewCuentaUsuario> createState() => _ViewCuentaUsuarioState();
}

class _ViewCuentaUsuarioState extends State<ViewCuentaUsuario> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center( child: Avatar(
          name: 'Usuario',
          shape: AvatarShape.circle(100)
        ), ),

        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: AspectRatio(
            aspectRatio: 10 / 12,
            child: TabContainer(
              tabExtent: 60,
              selectedTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.background,
              ),
              unselectedTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                'Datos\npersonales',
                'Ubicación',
                'Usuario'
              ],
              color: Theme.of(context).colorScheme.primary,
              children: const [
                TabDatosPersona(),
                TabDatosUbicacion(),
                TabDatosUsuario(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}