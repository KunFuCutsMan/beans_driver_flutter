import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormRegDatosUsuario extends StatefulWidget {

  final GlobalKey<FormBuilderState> formKey;
  final void Function() resultado;

  const FormRegDatosUsuario({super.key, required this.formKey, required this.resultado});

  @override
  State<FormRegDatosUsuario> createState() => _FormRegDatosUsuarioState();
}

class _FormRegDatosUsuarioState extends State<FormRegDatosUsuario> {
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
              Text("¿Quién eres?", style: Theme.of(context).textTheme.headlineMedium),

              // Nombre
              FormBuilderTextField(
                name: 'nombre',
                keyboardType: TextInputType.name,
                decoration: const InputDecoration( label: Text("Nombre:") ),
                validator: FormBuilderValidators.required(errorText: "Ingrese su nombre"),
              ),

              // Primer Apellido
              FormBuilderTextField(
                name: 'apellido_1',
                keyboardType: TextInputType.name,
                decoration: const InputDecoration( label: Text("Primer Apellido") ),
                validator: FormBuilderValidators.required(errorText: "Ingrese su primer apellido"),
              ),

              // Segundo Apellido
              FormBuilderTextField(
                name: 'apellido_2',
                keyboardType: TextInputType.name,
                decoration: const InputDecoration( label: Text("Segundo Apellido:") ),
              ),

              // Géneros
              FormBuilderRadioGroup<String>(
                name: 'genero',
                decoration: const InputDecoration( label: Text("Género:") ),
                orientation: OptionsOrientation.vertical,
                validator: FormBuilderValidators.required(errorText: "Ingrese su género"),
                options: const [
                  FormBuilderFieldOption(value: 'M', child: Text("Masculino", style: TextStyle( fontSize: 20 ), ), ),
                  FormBuilderFieldOption(value: 'F', child: Text("Femenino", style: TextStyle( fontSize: 20 ), ), ),
                  FormBuilderFieldOption(value: 'I', child: Text("Indistinto", style: TextStyle( fontSize: 20 ), ), ),
                ],
              ),

              // Número telefónico
              FormBuilderTextField(
                name: 'num_tel',
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration( label: Text("Número telefónico:") ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "Ingrese su número telefónico"),
                  FormBuilderValidators.numeric(errorText: "Ingrese un número telefónico válido"),
                  FormBuilderValidators.match("^[0-9]+\$", errorText: "Ingrese un número telefónico válido"),
                  FormBuilderValidators.equalLength(10, errorText: "Su número telefónico debe incluir 10 números"),
                ]),
              ),
            ],
          )
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
          child: const Text("Siguiente"),
        )
      ],
    );
  }
}