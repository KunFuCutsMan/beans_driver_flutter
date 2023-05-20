import 'dart:developer';

import 'package:beans_driver_flutter/src/comun/dialogo_alerta.dart';
import 'package:beans_driver_flutter/src/comun/dropdown_ubicacion.dart';
import 'package:beans_driver_flutter/src/modelos/persona.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TabDatosUbicacion extends StatefulWidget {
  
  final Persona per;
  const TabDatosUbicacion({super.key, required this.per});

  @override
  State<TabDatosUbicacion> createState() => _TabDatosUbicacionState();
}

class _TabDatosUbicacionState extends State<TabDatosUbicacion> {

  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  // Método de validación
  void _validaFormulario() async {
    
    log("Validando...");

    if (formKey.currentState?.saveAndValidate() ?? false) {
      log("Validado");

      widget.per.estadoID = formKey.currentState?.value['estadoID'];
      widget.per.municipioID = formKey.currentState?.value['municipioID'];
      widget.per.localidadID = formKey.currentState?.value['localidadID'];

      Map<String, dynamic> res = await widget.per.editaEnDB();

      if ( res['stat'] == 200 && res['_'] == true ) {
        return DialogoAlerta.avisaInfo( formKey.currentContext! , "Se editaron sus datos con éxito");
      } else {
        return DialogoAlerta.avisaInfo( formKey.currentContext!, "Hubo un error al editar sus datos: ${res['error']}");
      }
    }
    else {
      log("No se pudo");
      return DialogoAlerta.avisaInfo( formKey.currentContext!, 'Hubo un error al editar la persona: Datos incorrectos o nulos');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( child: FormBuilder(
      key: formKey,
      onChanged: () => formKey.currentState?.save(),

      child: Wrap(
        runSpacing: 15,
        alignment: WrapAlignment.center,
        children: [

          DropdownUbicacion(
            estadoNombre: 'estadoID',
            municipioNombre: 'municipioID',
            localidadNombre: 'localidadID',
            decoracion: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
            estadoID: widget.per.estadoID,
            municipioID: widget.per.municipioID,
            localidadID: widget.per.localidadID,
          ),

          ElevatedButton(
            onPressed: _validaFormulario,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary
            ),
            child: Text("Editar", style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSecondary
            ), )
          ),
        ],
      ), ),
    );
  }
}