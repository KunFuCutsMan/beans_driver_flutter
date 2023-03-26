import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormLoginUsuario extends StatefulWidget {
  
  
  final GlobalKey<FormBuilderState> formKey;
  final void Function() resultado;
  
  const FormLoginUsuario({super.key, required this.formKey, required this.resultado});

  @override
  State<FormLoginUsuario> createState() => _FormLoginUsuarioState();
}

class _FormLoginUsuarioState extends State<FormLoginUsuario> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        
        FormBuilder(
          key: widget.formKey,
          skipDisabled: true,
          onChanged: () => widget.formKey.currentState?.save(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Beans Driver",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              Image.asset("assets/images/bean_face.png", fit: BoxFit.scaleDown ),

              FormBuilderTextField(
                name: 'correo',
                enableSuggestions: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration( label: Text("Correo electrónico:") ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "Ingrese un correo electrónico"),
                  FormBuilderValidators.email(errorText: "Ingrese un correo electrónico válido"),
                ]),
              ),

              FormBuilderTextField(
                name: 'contrasena',
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration( label: Text("Contraseña") ),
                validator: FormBuilderValidators.required(errorText: "Ingrese su contraseña"),
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
          child: const Text("INICIAR SESIÓN"),
        ),
      ],
    );
  }
}