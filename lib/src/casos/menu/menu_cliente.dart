import 'package:beans_driver_flutter/src/casos/menu/drawer_usuario.dart';
import 'package:beans_driver_flutter/src/comun/app_barra.dart';
import 'package:beans_driver_flutter/src/modelos/persona.dart';
import 'package:beans_driver_flutter/src/modelos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      usu = Usuario(usuarioID: prefs.getInt("usuarioID")! );
      await usu.obtenUsuarioEnDB();
      usu.contrasena = prefs.getString("usuarioContra");

      per = Persona(personaID: usu.personaID!);
      await per.obtenPersonaEnDB();

      setState(() { usu; per; });
    }();

  }

  // Muchas gracias a Sneh Mehta:
  // https://snehmehta.medium.com/dynamic-bottom-navigation-with-go-router-flutter-power-series-part-1-2437e2d72546
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarra(),
      drawer: DrawerUsuario(per: per, usu: usu,),
      body: widget.cuerpo,
      
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 16.0,
        selectedItemColor: Theme.of(context).colorScheme.onBackground,

        currentIndex: _calculaIndexActual( context ),
        onTap: _onTap,
        
        items: [
          BottomNavigationBarItem(
            icon: const Icon( Icons.room_service_outlined ),
            activeIcon: const Icon( Icons.room_service ),
            label: usu.rolUsuarioID == 1
              ? "Pedir Servicio"
              : usu.rolUsuarioID == 2
                ? "Dar Servicio"
                : "Servicio" ,
          ), 
          const BottomNavigationBarItem(
            icon: Icon( Icons.home_outlined ),
            activeIcon: Icon( Icons.home ),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            activeIcon: Icon( Icons.person ),
            label: "Cuenta",
          ),
        ],
      ),
    );
  }
  
  int _calculaIndexActual( BuildContext context ) {
    final GoRouter ruta = GoRouter.of(context);
    final String location = ruta.location;

    if ( location.startsWith('/servicio') ) {
      return 0;
    }
    if ( location.startsWith('/home') ) {
      return 1;
    }
    if ( location.startsWith('/cuenta') ) {
      return 2;
    }

    return 0;
  }

  void _onTap(int value) {
    switch ( value ) {
      case 0: return context.go('/servicio/${usu.rolUsuarioID}/${per.personaID}/${usu.usuarioID}');
      case 1: return context.go('/home');
      case 2: return context.go('/cuenta/${usu.usuarioID}/${per.personaID}');
      default: return context.go('/servicio/${usu.rolUsuarioID}');
    }
  }
}
