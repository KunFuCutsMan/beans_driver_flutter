
import 'package:beans_driver_flutter/src/casos/registro/form_registro_rol_usuario.dart';
import 'package:beans_driver_flutter/src/casos/registro/form_registro_ubi_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PantallaRegistro extends StatefulWidget {

  final GlobalKey<FormBuilderState> llaveFormulario = GlobalKey<FormBuilderState>();

  PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {

  int _indexActivo = 0;

  void _aumentaIndex() {
    setState(() {
      _indexActivo++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [ 0.2, 0.9 ],
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.background
          ],
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.all(40),
        child: ListView( children: [ construyeFormularios() ], ),
      ),
    );
  }

  Widget construyeFormularios() {
    switch ( _indexActivo ) {
      
      case 0: return FormRegRolUsuario(
        formKey: widget.llaveFormulario,
        resultado: _aumentaIndex,
      );

      case 1: return FormRegUbicacionUsuario(
        formKey: widget.llaveFormulario,
        resultado: _aumentaIndex
      );

      case 2: return const Text("formulario 3");

      case 3: return const Text("formulario 4");
      
      default: return FormRegRolUsuario(
        formKey: widget.llaveFormulario,
        resultado: _aumentaIndex,
      );
    }
  }
}