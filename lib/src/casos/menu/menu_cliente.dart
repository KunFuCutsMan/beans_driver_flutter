import 'package:beans_driver_flutter/src/casos/menu/drawer_usuario.dart';
import 'package:beans_driver_flutter/src/comun/app_barra.dart';
import 'package:beans_driver_flutter/src/modelos/persona.dart';
import 'package:beans_driver_flutter/src/modelos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key, required this.cuerpo}) : super(key: key);

  final Widget cuerpo;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Usuario usu = Usuario(usuarioID: 0);
  Persona per = Persona(personaID: 0);

  @override
  void initState() {
    super.initState();

    () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      usu = Usuario(usuarioID: prefs.getInt("usuarioID")!);
      await usu.obtenUsuarioEnDB();
      usu.contrasena = prefs.getString("usuarioContra");

      per = Persona(personaID: usu.personaID!);
      await per.obtenPersonaEnDB();

      setState(() {
        usu;
        per;
      });
    }();
  }

  // Muchas gracias a Sneh Mehta:
  // https://snehmehta.medium.com/dynamic-bottom-navigation-with-go-router-flutter-power-series-part-1-2437e2d72546
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarra(),
      drawer: DrawerUsuario(
        per: per,
        usu: usu,
      ),
      body: widget.cuerpo,
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
          child: GNav(
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            color: Theme.of(context).colorScheme.onPrimary,
            activeColor: Theme.of(context).colorScheme.onPrimary,
            tabBackgroundColor: Theme.of(context).colorScheme.primary,
            gap: 8,
            onTabChange: (index) {
              _calculaIndexActual(context);
              _onTap(index);
            },
            padding: const EdgeInsets.all(16),
            tabs: [
              GButton(
                icon: Icons.directions_car,
                iconColor: Theme.of(context).colorScheme.onBackground,
                text: usu.rolUsuarioID == 1
                    ? "Pedir Servicio"
                    : usu.rolUsuarioID == 2
                        ? "Dar Servicio"
                        : "Servicio",
              ),
              GButton(
                icon: Icons.home,
                iconColor: Theme.of(context).colorScheme.onBackground,
                text: "Inicio",
              ),
              GButton(
                icon: Icons.person,
                iconColor: Theme.of(context).colorScheme.onBackground,
                text: "Cuenta",
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculaIndexActual(BuildContext context) {
    final GoRouter ruta = GoRouter.of(context);
    final String location = ruta.location;

    if (location.startsWith('/servicio')) {
      return 0;
    }
    if (location.startsWith('/home')) {
      return 1;
    }
    if (location.startsWith('/cuenta')) {
      return 2;
    }

    return 0;
  }

  void _onTap(int value) {
    switch (value) {
      case 0:
        return context.go(
            '/servicio/${usu.rolUsuarioID}/${per.personaID}/${usu.usuarioID}');
      case 1:
        return context.go('/home/${usu.rolUsuarioID}/${usu.usuarioID}');
      case 2:
        return context.go('/cuenta/${usu.usuarioID}/${per.personaID}');
      default:
        return context.go('/servicio/${usu.rolUsuarioID}');
    }
  }
}
