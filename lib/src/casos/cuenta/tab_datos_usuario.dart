import 'dart:developer';

import 'package:beans_driver_flutter/src/comun/dialogo_alerta.dart';
import 'package:beans_driver_flutter/src/comun/dialogo_login.dart';
import 'package:beans_driver_flutter/src/modelos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabDatosUsuario extends StatefulWidget {
  
  final Usuario usu;
  const TabDatosUsuario({super.key, required this.usu});

  @override
  State<TabDatosUsuario> createState() => _TabDatosUsuarioState();
}

class _TabDatosUsuarioState extends State<TabDatosUsuario> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  void _editaDatosUsuario() async {
    log("Validando...");

    if ( formKey.currentState?.saveAndValidate() ?? false ) {
      log("Validado");

      SharedPreferences prefs = await SharedPreferences.getInstance();

      widget.usu.usuarioID = prefs.getInt('usuarioID') ?? 0;
      widget.usu.correo = formKey.currentState?.value['correo'];
      widget.usu.contrasena = formKey.currentState?.value['contrasena'];

      log( widget.usu.toString() );

      Map<String, dynamic> res = await widget.usu.editaUsuarioEnDB();

      if ( res['stat'] == 200 && res['_'] ) {
        await Future.wait([
          prefs.setString("usuarioCorreo", "${widget.usu.correo}"),
          prefs.setString("usuarioContra", "${widget.usu.contrasena}"),
        ]);

        return DialogoAlerta.avisaInfo( formKey.currentContext!,
          "Se editaron sus datos exitosamente");
      }
      else {
        return DialogoAlerta.avisaInfo( formKey.currentContext!,
          "Hubo un error al modificar los datos del usuario: ${ res['error'] }");
      }

    }
    else {
      log("No se pudo");
      return DialogoAlerta.avisaInfo(context, "Hubo un error al modificar los datos del usuario: Datos incorrectos o nulos");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView( child: FormBuilder(
      key: formKey,
      initialValue: {
        'correo': widget.usu.correo,
        'contrasena': widget.usu.contrasena,
      },

      child: Wrap(
        runSpacing: 15,
        alignment: WrapAlignment.center,
        children: [
          
          FormBuilderTextField(
            name: 'correo',
            enableSuggestions: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              label: const Text("Correo electrónico:"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
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
            decoration: InputDecoration(
              label: const Text("Contraseña"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
            validator: FormBuilderValidators.required(errorText: "Ingrese su contraseña"),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary
            ),
            child: Text("Editar", style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSecondary
            ), ),
            onPressed: () => DialogoLogin.avisaLogin(context, _editaDatosUsuario),
          ),
        ],
      ), ),
    );
  }
}