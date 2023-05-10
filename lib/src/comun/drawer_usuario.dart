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
      child: Column(
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

          const Divider( thickness: 2, ),
          ListTile(
            title: const Text("Cerrar sesión"),
            leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.onBackground,),
            onTap: _cierraSesion,
          ),

          const Divider( thickness: 2, ),
          SwitchListTile(
            value: Theme.of(context).brightness == Brightness.dark,
            title: const Text("Tema Oscuro"),
            onChanged: _cambiaTema,
          ),
          
          const Divider( thickness: 2, ),
          const SizedBox( height: 40, ),

          const Divider( thickness: 2, ),
          ListTile(
            title: const Text("Compartir"),
            leading: Icon( Icons.share, color: Theme.of(context).colorScheme.onBackground, ),
            onTap: _comparteApp,
          ),

          const Divider( thickness: 2, ),
          ListTile(
            title: const Text("Dev Notes"),
            leading: Icon( Icons.logo_dev, color: Theme.of(context).colorScheme.onBackground, ),
            onTap: _muestraNotas,
          ),
          
          const Divider( thickness: 2, ),
          ListTile(
            title: const Text("Ayuda"),
            leading: Icon( Icons.question_mark, color: Theme.of(context).colorScheme.onBackground ),
            onTap: _enlazaSitio,
          ),

          const Divider( thickness: 2, ),
          const SizedBox(height: 80, ),

          const Divider( thickness: 2, ),
          ListTile(
            title: const Text("Canjear código"),
            leading: Icon(Icons.password, color: Theme.of(context).colorScheme.onBackground ),
            onTap: _canjeaCodigo,
          ),

          const Divider( thickness: 4, ),

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

  void _cambiaTema(bool isOscuro) {
    if ( isOscuro ) {
      BeansDriver.of(context).changeTheme( ThemeMode.dark );
    }
    else {
      BeansDriver.of(context).changeTheme( ThemeMode.light );
    }
  }

  void _comparteApp() {
  }

  void _enlazaSitio() {
  }

  void _canjeaCodigo() {
  }

  void _muestraNotas() {
  }
}