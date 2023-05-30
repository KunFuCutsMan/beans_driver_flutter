import 'dart:developer';

import 'package:beans_driver_flutter/src/casos/login/form_login_usuario.dart';
import 'package:beans_driver_flutter/src/comun/app_barra.dart';
import 'package:beans_driver_flutter/src/comun/dialogo_alerta.dart';
import 'package:beans_driver_flutter/src/modelos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaLogin extends StatefulWidget {
  
  final GlobalKey<FormBuilderState> llaveFormulario = GlobalKey<FormBuilderState>();
  
  PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarra(),

      body: Container(
        padding: const EdgeInsets.only(top: 60, left: 40, right: 40, bottom: 40),

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [ 0.2, 0.9 ],
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
    
        child: ListView(
          children: [
            FormLoginUsuario(
              formKey: widget.llaveFormulario,
              resultado: () => validaLogin(
                resultado: ( usuarioID, rolUsuarioID ) => context.go('/home/$rolUsuarioID/$usuarioID'),
              ),
            ),
    
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("¿Aún no tienes una cuenta?"),
                TextButton(
                  onPressed: () => context.go("/registro"),
                  child: const Text("Registrate aquí")
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void validaLogin({ required void Function( int usuarioID, int rolUsuarioID ) resultado }) async {
    Usuario usu = Usuario(usuarioID: 0);
    usu.correo = widget.llaveFormulario.currentState?.value['correo'] ?? "";
    usu.contrasena = widget.llaveFormulario.currentState?.value['contrasena'] ?? "";

    Map<String, dynamic> res = await usu.validaLogin();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    if ( res['_']['loginValido'] ) {
      // Ahora la aplicación sabe que estás logeado
      await Future.wait([
        prefs.setBool("usuarioTieneLogin", true),
        prefs.setString("usuarioCorreo", "${usu.correo}"),
        prefs.setString("usuarioContra", "${usu.contrasena}"),
        prefs.setInt("usuarioID", int.parse(res['_']['usuarioID']) ),
      ]);

      resultado.call( int.parse(res['_']['usuarioID']), int.parse(res['_']['rolUsuarioID']) );
    }
    else {
      // Ahora la aplicación sabe que no estás logeado
      await Future.wait([
        prefs.setBool("usuarioTieneLogin", false),
        prefs.setString("usuarioCorreo", ""),
        prefs.setString("usuarioContra", ""),
        prefs.setInt("usuarioID", 0),
      ]);

      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        builder: (context) => DialogoAlerta(
          titulo: "Error en el inicio sesión",
          contenido: "Hubo un error al iniciar la sesión: ${res['error']}",
          acciones: { 'OK': () {} },
          icono: Icons.error_outline
      ));
    }
  }
}