import 'dart:convert';
import 'dart:io';

import 'package:beans_driver_flutter/src/comun/dialogo_alerta.dart';
import 'package:beans_driver_flutter/src/comun/dialogo_login.dart';
import 'package:beans_driver_flutter/src/modelos/conecta_sql.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialogoEditaAvatar extends StatefulWidget {
  const DialogoEditaAvatar({super.key});

  static void avisaEdita( BuildContext context ) async {
    return await showDialog(
      context: context,
      builder: (context) => const DialogoEditaAvatar(),
    );
  }

  @override
  State<DialogoEditaAvatar> createState() => _DialogoEditaAvatarState();
}

class _DialogoEditaAvatarState extends State<DialogoEditaAvatar> {

  XFile? image;

  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    if ( img != null ) {
      setState(() => image = img);
    }
  }

  void _actualizaAvatar( BuildContext context ) async {
    // Crea el conectador y obten nuestra ID
    ConectaSQL con = ConectaSQL();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> res = await con.post(path: "usuario/avatar/upload", params: {
      "usuarioID": "${prefs.getInt("usuarioID")}",
      "imagen": base64Encode( await image!.readAsBytes() ),
    });

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    if ( res['stat'] == 200 && res['_'] ) {
      // ignore: use_build_context_synchronously
      return DialogoAlerta.avisaInfo(context, "Su avatar se editó con éxito");
    }
    else {
      // ignore: use_build_context_synchronously
      return DialogoAlerta.avisaInfo(context, "Hubo un error al editar su avatar: ${res['error']}" );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar Avatar"),
      content: SingleChildScrollView( child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          image != null
            ? Image.file( File( image!.path ), fit: BoxFit.cover, )
            : const Text("No has seleccionado una imagen", textAlign: TextAlign.center,),

          const Text("Recomendamos utilizar una imagen cuadrada", textAlign: TextAlign.center,),

          ElevatedButton(
            child: const Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.image_outlined),
                Text("Desde Galería")
              ],
            ),

            onPressed: () => getImage( ImageSource.gallery ),
          ),

          ElevatedButton(
            child: const Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.camera_alt_outlined),
                Text("Desde Cámara")
              ],
            ),

            onPressed: () => getImage( ImageSource.camera ),
          ),

          TextButton(
            onPressed: image != null
              ? () => DialogoLogin.avisaLogin(context, () => _actualizaAvatar( context ) )
              : null,
            
            child: Text("Editar",
              style: image == null
                ? Theme.of(context).textTheme.bodyMedium : null,
            ),
          ),
        ],
      ), ),
    );
  }
}