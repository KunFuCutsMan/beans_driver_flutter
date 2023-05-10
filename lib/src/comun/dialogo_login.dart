import 'package:beans_driver_flutter/src/comun/dialogo_alerta.dart';
import 'package:beans_driver_flutter/src/modelos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class DialogoLogin extends StatelessWidget {
  
  void Function() onSuccess;
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  DialogoLogin({super.key, required this.onSuccess});

  static void avisaLogin(BuildContext context, void Function() onSuccess) async {
    return await showDialog(
      context: context,
      builder: (context) => DialogoLogin( onSuccess: onSuccess ),
      barrierDismissible: false,
    );
  }

  Future<bool> _valoresSonMismosQueCuenta({ required String correo, required String contrasena }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String correoGuardado = prefs.getString("usuarioCorreo") ?? "";
    String contrasenaGuardada = prefs.getString("usuarioContra") ?? "";

    return correoGuardado == correo && contrasenaGuardada == contrasena;
  }

  void _validaFormulario() async {
    Usuario usu = Usuario(
      usuarioID: 0,
      correo: formKey.currentState?.value['correo'] ?? "",
      contrasena: formKey.currentState?.value['contrasena'] ?? "",
    );

    bool formularioValido = formKey.currentState?.saveAndValidate() ?? false;
    bool usuarioEsMismo = await _valoresSonMismosQueCuenta(
      correo: usu.correo!,
      contrasena: usu.contrasena!,
    );
    
    if ( usuarioEsMismo && formularioValido ) {
      // Checa que valide el login
      Map<String, dynamic> res = await usu.validaLogin();

      if ( res['stat'] == 200 && res['_']['loginValido'] ) {
        // Se validó el login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await Future.wait([
          prefs.setBool("usuarioTieneLogin", true),
          prefs.setString("usuarioCorreo", "${usu.correo}"),
          prefs.setString("usuarioContra", "${usu.contrasena}"),
          prefs.setInt("usuarioID", int.parse(res['_']['usuarioID']) ),
        ]);

        return onSuccess.call();
      }
      else {
        // Login inválido
        return DialogoAlerta.avisaInfo(
          formKey.currentContext!,
          "Hubo un error al validar sus datos: ${ res['error'] }",
        );
      }

    }
    else {
      // Datos incorrectos en el login
      return DialogoAlerta.avisaInfo(
        formKey.currentContext!,
        "Hubo un error al validar sus datos: Datos incorrectos o nulos",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Alerta"),
      icon: const Icon( Icons.login ),
      content: SingleChildScrollView( child: FormBuilder(

        key: formKey,
        onChanged: () => formKey.currentState?.save(),

        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 15,
          children: [

            const Text("Para realizar esta acción, requerimos confirmar que es usted."),
            const Text("Por favor inicia sesión para continuar:"),
            
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
        ),
      ) ),
      actions: [

        // Botón cancelar
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar", textAlign: TextAlign.end ),
        ),

        // Botón login
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _validaFormulario();
          },
          child: const Text("Login", textAlign: TextAlign.end ),
        ),
      ],
    );
  }
}