import 'dart:developer';

import 'package:beans_driver_flutter/src/casos/login/form_login_usuario.dart';
import 'package:beans_driver_flutter/src/comun/dialogo_alerta.dart';
import 'package:beans_driver_flutter/src/modelos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

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
      appBar: AppBar( title: const Text("Beans Driver"), ),

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
              resultado: () async {
                Usuario usu = Usuario(usuarioID: 0);
                usu.correo = widget.llaveFormulario.currentState?.value['correo'] ?? "";
                usu.contrasena = widget.llaveFormulario.currentState?.value['contrasena'] ?? "";

                Map<String, dynamic> res = await usu.validaLogin();

                if ( res['_'] ) {
                  // ignore: use_build_context_synchronously
                  await showDialog(
                    context: context,
                    builder: (context) => DialogoAlerta(
                      titulo: "Sesión iniciada",
                      contenido: "Su sesión ha sido iniciada",
                      acciones: {
                        'OK': () => log("acción tomada")
                      },
                      icono: Icons.login
                  ));
                }
                else {
                  // ignore: use_build_context_synchronously
                  await showDialog(
                    context: context,
                    builder: (context) => DialogoAlerta(
                      titulo: "Error en el inicio sesión",
                      contenido: "Hubo un error al iniciar la sesión: ${res['error']}",
                      acciones: {
                        'OK': () => log("acción tomada")
                      },
                      icono: Icons.error_outline
                  ));
                }
              },
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
}