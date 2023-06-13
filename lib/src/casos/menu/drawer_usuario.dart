import 'package:beans_driver_flutter/main.dart';
import 'package:beans_driver_flutter/src/comun/avatar_usuario.dart';
import 'package:beans_driver_flutter/src/modelos/persona.dart';
import 'package:beans_driver_flutter/src/modelos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerUsuario extends StatefulWidget {

  final Persona per;
  final Usuario usu;

  const DrawerUsuario({super.key, required this.per, required this.usu});

  @override
  State<DrawerUsuario> createState() => _DrawerUsuarioState();
}

class _DrawerUsuarioState extends State<DrawerUsuario> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          UserAccountsDrawerHeader(
            accountName: Text("${widget.per.nombre} ${widget.per.apePrimero} ${widget.per.apeSegundo}"),
            accountEmail: Text("${widget.usu.correo}"),
            currentAccountPictureSize: const Size.square(80),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
            child: AvatarUsuario(usu: widget.usu, per: widget.per, permiteEditar: false),
            ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              image: const DecorationImage(image: AssetImage('assets/images/background_decoration.png'), fit: BoxFit.cover),
            ),
          ),

          const SizedBox( height: 12, ),

          const Row(
            children: [
            Expanded(child: Divider(thickness: 2,)),
            Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Ajustes'),
            ),
            Expanded(child: Divider(thickness: 2,)),
            ],
          ),

          SwitchListTile(
            value: Theme.of(context).brightness == Brightness.dark,
            title: const Text("Tema Oscuro"),
            secondary: Icon(Icons.mode_night, color: Theme.of(context).colorScheme.onBackground,),
            onChanged: _cambiaTema,
          ),

          ListTile(
            title: const Text("Cerrar sesión"),
            leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.onBackground,),
            onTap: _cierraSesion,
          ),

          const SizedBox( height: 5, ),

          const Row(
            children: [
            Expanded(child: Divider(thickness: 2,)),
            Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Social e Informativo'),
            ),
            Expanded(child: Divider(thickness: 2,)),
            ],
          ),

          const SizedBox( height: 5, ),
      
          ListTile(
            title: const Text("Compartir"),
            leading: Icon( Icons.share, color: Theme.of(context).colorScheme.onBackground, ),
            onTap: _comparteApp,
          ),

          ListTile(
            title: const Text("Dev Notes"),
            leading: Icon( Icons.logo_dev, color: Theme.of(context).colorScheme.onBackground, ),
            onTap: _muestraNotas,
          ),
          
          ListTile(
            title: const Text("Ayuda"),
            leading: Icon( Icons.question_mark, color: Theme.of(context).colorScheme.onBackground ),
            onTap: _enlazaSitio,
          ),

          const SizedBox( height: 5, ),

          const Row(
            children: [
            Expanded(child: Divider(thickness: 2,)),
            Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Codigos Promocionales'),
            ),
            Expanded(child: Divider(thickness: 2,)),
            ],
          ),

          const SizedBox( height: 5, ),
         
          ListTile(
            title: const Text("Canjear código"),
            leading: Icon(Icons.password, color: Theme.of(context).colorScheme.onBackground ),
            onTap: _canjeaCodigo,
          ),

          //const Divider( thickness: 4, ),

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
