import 'package:flutter/material.dart';

class DrawerUsuario extends StatefulWidget {
  const DrawerUsuario({super.key});

  @override
  State<DrawerUsuario> createState() => _DrawerUsuarioState();
}

class _DrawerUsuarioState extends State<DrawerUsuario> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Opciones",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          ListTile(
            title: const Text("Acerca de"),
            onTap: () {},
          ),

          const Divider( thickness: 4, ),
          ListTile(
            title: const Text("Cerrar sesión"),
            onTap: () {},
          )
        ],
      ),
    );
  }
}