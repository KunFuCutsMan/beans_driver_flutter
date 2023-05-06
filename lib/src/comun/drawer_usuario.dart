import 'package:beans_driver_flutter/main.dart';
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
      backgroundColor: Theme.of(context).colorScheme.background,
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

          const Divider( thickness: 4, ),
          ListTile(
            title: const Text("Cerrar sesión"),
            onTap: _cierraSesion,
          ),

          const Divider( thickness: 4, ),
          SwitchListTile(
            value: Theme.of(context).brightness == Brightness.dark,
            title: const Text("Tema Oscuro"),
            onChanged: (bool isOscuro) {
              if ( isOscuro ) {
                BeansDriver.of(context).changeTheme( ThemeMode.dark );
              }
              else {
                BeansDriver.of(context).changeTheme( ThemeMode.light );
              }
            },
          ),
          
          const Divider( thickness: 4, ),
          ListTile(
            title: const Text("Compartir"),
            leading: Icon( Icons.share, color: Theme.of(context).colorScheme.onBackground, ),
            onTap: () {},
          ),
          
          const Divider( thickness: 4, ),
          ListTile(
            title: const Text("Ayuda"),
            leading: Icon( Icons.question_mark, color: Theme.of(context).colorScheme.onBackground ),
            onTap: () {},
          ),

        ],
      ),
    );
  }

  void _cierraSesion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool("usuarioTieneLogin", false),
      prefs.setString("usuarioCorreo", ""),
      prefs.setString("usuarioContra", ""),
      prefs.setInt("usuarioID", 0),
    ]);

    // ignore: use_build_context_synchronously
    return context.go('/login'); 
  }
}