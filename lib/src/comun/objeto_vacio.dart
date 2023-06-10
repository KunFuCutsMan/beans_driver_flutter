import 'package:flutter/material.dart';

class ObjetoVacio extends StatelessWidget {
  final String mensaje;
  const ObjetoVacio({super.key, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/bean_lineado.png", fit: BoxFit.scaleDown),
          Text(mensaje, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}