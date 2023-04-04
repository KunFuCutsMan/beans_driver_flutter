
import 'dart:developer';

import 'package:beans_driver_flutter/src/casos/registro/form_registro_cuenta_usuario.dart';
import 'package:beans_driver_flutter/src/casos/registro/form_registro_datos_usuario.dart';
import 'package:beans_driver_flutter/src/casos/registro/form_registro_rol_usuario.dart';
import 'package:beans_driver_flutter/src/casos/registro/form_registro_ubi_usuario.dart';
import 'package:beans_driver_flutter/src/comun/dialogo_alerta.dart';
import 'package:beans_driver_flutter/src/modelos/persona.dart';
import 'package:beans_driver_flutter/src/modelos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:im_stepper/stepper.dart';

class PantallaRegistro extends StatefulWidget {

  final GlobalKey<FormBuilderState> llaveFormulario = GlobalKey<FormBuilderState>();

  PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {

  int _indexActivo = 0;
  final int _indexTotal = 4;
  final Usuario usuario = Usuario(usuarioID: 0);
  final Persona persona = Persona(personaID: 0);

  void _aumentaIndex() {
    setState(() {
      _indexActivo++;
    });
  }

  Future<void> registraDatos() async {
     // Inserta a la persona
    Map<String, dynamic> resPersona = await persona.insertaEnDB();

    if ( resPersona['stat'] != 200 ) {
      // ignore: use_build_context_synchronously
      return showDialog(
        context: context,
        builder: (context) => DialogoAlerta(
          titulo: "Error con el servidor",
          contenido: "Hubo un error con el ingreso de datos personales: ${resPersona['error']}",
          acciones: {
            'OK': () => log("Acción tomada")
          },
          icono: Icons.error_outline),
      );
    }
    
    // Obten la ID de la persona
    persona.personaID = int.parse( resPersona['_']['personaID'] );
    usuario.personaID = persona.personaID;

    // E inserta al usuario
    Map<String, dynamic> resUsuario = await usuario.insertaEnDB();

    if ( resUsuario['stat'] != 200 ) {
      // ignore: use_build_context_synchronously
      return showDialog(
        context: context,
        builder: (context) => DialogoAlerta(
          titulo: "Error con el servidor",
          contenido: "Hubo un error con el ingreso de la cuenta: ${resUsuario['error']}",
          acciones: {
            'OK': () => log("Acción tomada")
          },
          icono: Icons.error_outline),
      );
    }

    // Obten la ID del usuario
    usuario.usuarioID = int.parse( resUsuario['_']['usuarioID'] );

    // Manda que se creó los datos, faltan activarlo
    // ignore: use_build_context_synchronously
    return showDialog(
      context: context,
      builder: (context) => DialogoAlerta(
        titulo: "Usuario creado",
        icono: Icons.person,
        contenido: "Su usuario ha sido creado.\nSolo requerimos que revise su correo electrónico para activar su cuenta.",
        acciones: {
          'Enviar correo': () async => await enviaCorreoAUsuario()
        }
      ),
    );
  }

  Future<void> enviaCorreoAUsuario() async {

    Map<String, dynamic> resCorreo = await usuario.enviaCorreoActivacion();

    if ( resCorreo['stat'] != 200 ) {
      // ignore: use_build_context_synchronously
      return showDialog(
        context: context,
        builder: (context) => DialogoAlerta(
          titulo: "Error con el servidor",
          contenido: "Hubo un error al enviar su correo de activación: ${ resCorreo['error'] }",
          acciones: {
            'OK': () => log("Acción tomada")
          },
          icono: Icons.error_outline),
      );
    }
    else {
      // ignore: use_build_context_synchronously
      return showDialog(
      context: context,
      builder: (context) => DialogoAlerta(
        titulo: "Correo enviado",
        contenido: "Su correo de activación ha sido enviado al correo: ${usuario.correo}\n",
        acciones: {
          'OK': () => log("Acción tomada")
        },
        icono: Icons.email_outlined)
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          padding: const EdgeInsets.only(top: 80, bottom: 80, left: 40, right: 40),
          child: ListView(
            children: [
              construyeFormularios(),
              stepperCircular(),
            ],
          ),
        ),
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
          // Pasa los datos a la instancia de persona
          persona.estadoID = widget.llaveFormulario.currentState?.value['ubi_estado'] ?? 1;
          persona.municipioID = widget.llaveFormulario.currentState?.value['ubi_municipio'] ?? 1;
          persona.localidadID = widget.llaveFormulario.currentState?.value['ubi_localidad'] ?? 1;
          
          _aumentaIndex();
        }
      );

      case 2: return FormRegDatosUsuario(
        formKey: widget.llaveFormulario,
        resultado: () {
          // Pasa los datos a la instancia de usuario
          persona.nombre = widget.llaveFormulario.currentState?.value['nombre'] ?? '';
          persona.apePrimero = widget.llaveFormulario.currentState?.value['apellido_1'] ?? '';
          persona.apeSegundo = widget.llaveFormulario.currentState?.value['apellido_2'] ?? '';
          persona.genero = widget.llaveFormulario.currentState?.value['genero'] ?? '';
          persona.numTel = widget.llaveFormulario.currentState?.value['num_tel'] ?? '';

          _aumentaIndex();
        }
      );

      case 3: return FormRegCuentaUsuario(
        formKey: widget.llaveFormulario,
        resultado: () async {
          // Pasa los datos a la instancia de usuario
          usuario.correo = widget.llaveFormulario.currentState?.value['correo'] ?? '';
          usuario.contrasena = widget.llaveFormulario.currentState?.value['psw_1'] ?? '';

          await registraDatos();
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

  Widget stepperCircular() {
    return Padding(
      padding: const EdgeInsets.only( top: 20 ),
      child: Center( child: DotStepper(
          tappingEnabled: false,
          activeStep: _indexActivo,
          dotRadius: 8,
          dotCount: _indexTotal,
          shape: Shape.circle,
          spacing: Checkbox.width,
          indicator: Indicator.slide,
          fixedDotDecoration: FixedDotDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          indicatorDecoration: IndicatorDecoration(
            color: Theme.of(context).colorScheme.primary,
            strokeWidth: 0,
          ),
        ),
      ),
    );
  }
}