import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormRegRolUsuario extends StatefulWidget {

  final GlobalKey<FormBuilderState> formKey;
  final void Function() resultado;

  const FormRegRolUsuario({super.key, required this.formKey, required this.resultado});

  @override
  State<FormRegRolUsuario> createState() => _FormRegRolUsuarioState();
}

class _FormRegRolUsuarioState extends State<FormRegRolUsuario> {
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
              Text("Quiero ser...", style: Theme.of(context).textTheme.headlineMedium),

              FormBuilderRadioGroup(
                name: 'rol_usuario',
                orientation: OptionsOrientation.vertical,
                validator: FormBuilderValidators.required(errorText: "Seleccione un rol"),
                options: const [
                  FormBuilderFieldOption(value: 1, child: Text("Cliente", style: TextStyle( fontSize: 20 ), ), ),
                  FormBuilderFieldOption(value: 2, child: Text("Taxista", style: TextStyle( fontSize: 20 ), ), ),
                ],
              ),
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
        )
      ],
    );
  }
}