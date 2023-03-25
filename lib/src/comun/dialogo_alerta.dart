import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DialogoAlerta extends StatelessWidget {

  String titulo = '';
  String contenido = '';
  IconData icono;
  Map<String, void Function() > acciones;

  DialogoAlerta({
    super.key,
    required this.titulo,
    required this.contenido,
    required this.acciones,
    required this.icono
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo),
      icon: Icon(icono, size: 50,),
      content: Text(
        contenido,
        softWrap: true,
        textAlign: TextAlign.justify,
      ),
      actions: [
        for ( String accion in acciones.keys )
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              acciones[accion]!.call();
            },
            child: Text( accion ),
          )
      ],
    );
  }
}