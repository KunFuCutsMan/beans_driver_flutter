import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormRegCuentaUsuario extends StatefulWidget {

  final GlobalKey<FormBuilderState> formKey;
  final void Function() resultado;

  const FormRegCuentaUsuario({super.key, required this.formKey, required this.resultado});

  @override
  State<FormRegCuentaUsuario> createState() => _FormRegCuentaUsuarioState();
}

class _FormRegCuentaUsuarioState extends State<FormRegCuentaUsuario> {

  String _psw1 = '';
  String _psw2 = '';

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
              Text("Datos de tu cuenta", style: Theme.of(context).textTheme.headlineMedium),

              // Correo electrónico
              FormBuilderTextField(
                name: 'correo',
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration( label: Text("Correo electrónico:") ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "Ingrese un correo electrónico"),
                  FormBuilderValidators.email(errorText: "Ingrese un correo electrónico válido"),
                ]),
              ),

              // Contraseña 1
              FormBuilderTextField(
                name: 'psw_1',
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration( label: Text("Contraseña:") ),
                onChanged: (value) => setState(() { _psw1 = value ?? ''; }),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "Ingrese su contraseña"),
                  FormBuilderValidators.equal(_psw2, errorText: "Su contraseña no es la misma"),
                ]),
              ),

              // Contraseña 2
              FormBuilderTextField(
                name: 'psw_2',
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration( label: Text("Confirme su contraseña:") ),
                onChanged: (value) => setState(() { _psw2 = value ?? ''; }),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "Ingrese su contraseña"),
                  FormBuilderValidators.equal(_psw1, errorText: "Su contraseña no es la misma"),
                ]),
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
          child: const Text("Siguiente"),
        )
      ],
    );
  }
}