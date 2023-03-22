
import 'package:beans_driver_flutter/src/casos/registro/form_registro_cuenta_usuario.dart';
import 'package:beans_driver_flutter/src/casos/registro/form_registro_datos_usuario.dart';
import 'package:beans_driver_flutter/src/casos/registro/form_registro_rol_usuario.dart';
import 'package:beans_driver_flutter/src/casos/registro/form_registro_ubi_usuario.dart';
import 'package:beans_driver_flutter/src/modelos/usuario.dart';
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
  final Usuario usuario = Usuario(usuarioID: 0);

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
        resultado: () {
          // Pasa los datos a la instancia de usuario
          usuario.rolUsuarioID = widget.llaveFormulario.currentState?.value['rol_usuario'] ?? 0;

          _aumentaIndex();
        },
      );

      case 1: return FormRegUbicacionUsuario(
        formKey: widget.llaveFormulario,
        resultado: () {
          // Pasa los datos a la instancia de usuario
          // usuario.estadoID = widget.llaveFormulario.currentState?.value['ubi_estado'] ?? 1;
          // usuario.municipioID = widget.llaveFormulario.currentState?.value['ubi_municipio'] ?? 1;
          // usuario.localidadID = widget.llaveFormulario.currentState?.value['ubi_localidad'] ?? 1;
          
          _aumentaIndex();
        }
      );

      case 2: return FormRegDatosUsuario(
        formKey: widget.llaveFormulario,
        resultado: () {
          // Pasa los datos a la instancia de usuario
          // usuario.nombre = widget.llaveFormulario.currentState?.value['nombre'] ?? '';
          // usuario.apePrimero = widget.llaveFormulario.currentState?.value['apellido_1'] ?? '';
          // usuario.apeSegundo = widget.llaveFormulario.currentState?.value['apellido_2'] ?? '';
          // usuario.genero = widget.llaveFormulario.currentState?.value['genero'] ?? '';
          // usuario.numTel = widget.llaveFormulario.currentState?.value['num_tel'] ?? '';

          _aumentaIndex();
        }
      );

      case 3: return FormRegCuentaUsuario(
        formKey: widget.llaveFormulario,
        resultado: () async {
          // Pasa los datos a la instancia de usuario
          usuario.correo = widget.llaveFormulario.currentState?.value['correo'] ?? '';
          usuario.contrasena = widget.llaveFormulario.currentState?.value['psw_1'] ?? '';

          // await usuario.insertaEnDB();
        }
      );
      
      default: return FormRegRolUsuario(
        formKey: widget.llaveFormulario,
        resultado: () {
          // Pasa los datos a la instancia de usuario
          usuario.rolUsuarioID = widget.llaveFormulario.currentState?.value['rol_usuario'] ?? 0;

          _aumentaIndex();
        },
      );
    }
  }
}