import 'dart:developer';

import 'package:beans_driver_flutter/src/comun/dialogo_alerta.dart';
import 'package:beans_driver_flutter/src/modelos/persona.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class TabDatosPersona extends StatefulWidget {

  final Persona per;
  const TabDatosPersona({super.key, required this.per});


  @override
  State<TabDatosPersona> createState() => _TabDatosPersonaState();
}

class _TabDatosPersonaState extends State<TabDatosPersona> {

  late GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  void avisaError(BuildContext context, String message) async {
    return await showDialog(
      context: context,
      builder: (context) => DialogoAlerta(
        titulo: "Atención",
        contenido: message,
        acciones: { 'OK': (){} },
        icono: Icons.info
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( child: FormBuilder(
      key: formKey,
      onChanged: () => formKey.currentState?.save(),
      initialValue: {
        'nombre': widget.per.nombre ?? '',
        'apellido_1': widget.per.apePrimero ?? '',
        'apellido_2': widget.per.apeSegundo ?? '',
        'genero': widget.per.genero ?? 'I',
        'num_tel': widget.per.numTel ?? '',
      },
      
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FormBuilderTextField(
            name: 'nombre',
            enableSuggestions: true,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              label: const Text("Nombre:"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background
            ),
            validator: FormBuilderValidators.required(errorText: "Ingrese su nombre"),
          ),

          FormBuilderTextField(
            name: 'apellido_1',
            enableSuggestions: true,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              label: const Text("Primer Apellido"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
            validator: FormBuilderValidators.required(errorText: "Ingrese su primer apellido"),
          ),

          FormBuilderTextField(
            name: 'apellido_2',
            enableSuggestions: true,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              label: const Text("Segundo Apellido"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background
            ),
          ),

          FormBuilderDropdown<String>(
            name: 'genero',
            decoration: InputDecoration(
              label: const Text("Género:"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
            items: const [
              DropdownMenuItem(
                value: 'M',
                child: Text("Masculino"),
              ),
              DropdownMenuItem(
                value: 'F',
                child: Text("Femenino"),
              ),
              DropdownMenuItem(
                value: 'I',
                child: Text("Indistinto"),
              ),
            ],
            validator: FormBuilderValidators.required(errorText: "Ingrese su género"),
          ),

          FormBuilderTextField(
            name: 'num_tel',
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: InputDecoration(
              label: const Text("Número telefónico:"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.numeric(errorText: "Ingrese un número telefónico válido"),
              FormBuilderValidators.match("^[0-9]+\$", errorText: "Ingrese un número telefónico válido"),
              FormBuilderValidators.equalLength(10, errorText: "Su número telefónico debe incluir 10 números"),
            ]),
          ),

          ElevatedButton(
            onPressed: () async {
            log("validando...");

            if ( formKey.currentState?.saveAndValidate() ?? false ) {
              log("validado");

              widget.per.nombre = formKey.currentState?.value['nombre'];
              widget.per.apePrimero = formKey.currentState?.value['apellido_1'];
              widget.per.apeSegundo = formKey.currentState?.value['apellido_2'];
              widget.per.genero = formKey.currentState?.value['genero'];
              widget.per.numTel = formKey.currentState?.value['num_tel'];
              
              Map<String, dynamic> res = await widget.per.editaEnDB();
              
              if ( res['stat'] == 200 && res['_'] == true ) {
                // ignore: use_build_context_synchronously
                return avisaError(context, 'Se editó la persona exitosamente.');
              } else {
                // ignore: use_build_context_synchronously
                return avisaError(context, 'Hubo un error al editar la persona: ${res['error']}');
              }
            }
            else {
              log("no se pudo");
              // ignore: use_build_context_synchronously
              return avisaError(context, 'Hubo un error al editar la persona: Datos incorrectos o nulos');
            }
          },
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