import 'package:beans_driver_flutter/src/casos/login/form_login_usuario.dart';
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
    
        child: Padding(
          padding: const EdgeInsets.only(top: 60, bottom: 40, left: 40, right: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FormLoginUsuario(
                formKey: widget.llaveFormulario,
                resultado: () {},
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
      ),
    );
  }
}