import 'package:beans_driver_flutter/src/casos/cuenta/tab_datos_persona.dart';
import 'package:beans_driver_flutter/src/casos/cuenta/tab_datos_ubicacion.dart';
import 'package:beans_driver_flutter/src/casos/cuenta/tab_datos_usuario.dart';
import 'package:beans_driver_flutter/src/comun/avatar_usuario.dart';
import 'package:beans_driver_flutter/src/comun/tabbed_contenedor.dart';
import 'package:beans_driver_flutter/src/modelos/persona.dart';
import 'package:beans_driver_flutter/src/modelos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewCuentaUsuario extends StatefulWidget {

  final int usuarioID;
  final int personaID;
  const ViewCuentaUsuario({super.key, required this.usuarioID, required this.personaID});

  @override
  State<ViewCuentaUsuario> createState() => _ViewCuentaUsuarioState();
}

class _ViewCuentaUsuarioState extends State<ViewCuentaUsuario> {

  late Usuario usu = Usuario(usuarioID: 0);
  late Persona per = Persona(personaID: 0);

  // Esta variable nos servirá para indicar si nuestros datos se recolectaron
  // Se actualiza al final de la función asincrona de initState()
  bool _datosListos = false;

  @override
  void initState() {
    super.initState();

    usu.usuarioID = widget.usuarioID;
    per.personaID = widget.personaID;
    
    () async {

      await Future.wait([
        () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          usu.contrasena = prefs.getString("usuarioContra");
        }(),
        usu.obtenUsuarioEnDB(),
        per.obtenPersonaEnDB(),
      ]);

      setState((){ _datosListos = true; });
    }();

  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center( child: AvatarUsuario(usu: usu, per: per, permiteEditar: true,) ),

        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: AspectRatio(
            aspectRatio: 10 / 12,
            child: TabbedContenedor(
              tabs: const [
                'Datos\nPersonales',
                'Ubicación',
                'Cuenta',
              ],
              vistas: [
                _datosListos ? TabDatosPersona( per: per, ): const Text(""),
                _datosListos ? TabDatosUbicacion( per: per ): const Text(""),
                _datosListos ? TabDatosUsuario( usu: usu ): const Text(""),
              ]
            ),
          ),
        ),
      ],
    );
  }
}