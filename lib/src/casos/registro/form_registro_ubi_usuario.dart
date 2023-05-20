import 'dart:developer';

import 'package:beans_driver_flutter/src/comun/dropdown_ubicacion.dart';
import 'package:beans_driver_flutter/src/modelos/conecta_sql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormRegUbicacionUsuario extends StatefulWidget {

  final GlobalKey<FormBuilderState> formKey;
  final void Function() resultado;

  final ConectaSQL con = ConectaSQL();

  FormRegUbicacionUsuario({super.key, required this.formKey, required this.resultado});

  @override
  State<FormRegUbicacionUsuario> createState() => _FormRegUbicacionUsuarioState();
}

class _FormRegUbicacionUsuarioState extends State<FormRegUbicacionUsuario> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        FormBuilder(
          key: widget.formKey,
          skipDisabled: true,
          onChanged: () => widget.formKey.currentState?.save(),
          child: Column(
            children: [
              Text("¿Donde vives?", style: Theme.of(context).textTheme.headlineMedium),

              const DropdownUbicacion(
                estadoNombre: 'ubi_estado',
                municipioNombre: 'ubi_municipio',
                localidadNombre: 'ubi_localidades',
              )
            ],
          ),
        ),

        ElevatedButton(
          onPressed: () {
            log("validando...");

            if ( widget.formKey.currentState?.saveAndValidate() ?? false ) {
              log("validado");
              widget.resultado();
            }
            else {
              log("no se pudo");
            }
          },
          child: const Text("Siguiente")
        ),
      ],
    );
  }
}