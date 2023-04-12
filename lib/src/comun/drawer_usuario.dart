import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            onTap: _cierraSesion,
          )
        ],
      ),
    );
  }

  void _cierraSesion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool("usuarioTieneLogin", false),
      prefs.setString("usuarioCorreo", ""),
      prefs.setString("usuarioContra", "")
    ]);

    // ignore: use_build_context_synchronously
    return context.go('/login'); 
  }
}