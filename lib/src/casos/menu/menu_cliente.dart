import 'package:beans_driver_flutter/src/comun/app_barra.dart';
import 'package:beans_driver_flutter/src/comun/drawer_usuario.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class Menu extends StatefulWidget {
  const Menu({Key? key, required this.cuerpo}) : super(key: key);

  final Widget cuerpo;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  // Muchas gracias a Sneh Mehta:
  // https://snehmehta.medium.com/dynamic-bottom-navigation-with-go-router-flutter-power-series-part-1-2437e2d72546
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarra(),
      drawer: const DrawerUsuario(),
      body: widget.cuerpo,
      
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 16.0,
        selectedItemColor: Theme.of(context).colorScheme.onBackground,

        currentIndex: _calculaIndexActual( context ),
        onTap: _onTap,
        
        items: const [
          BottomNavigationBarItem(
            icon: Icon( Icons.room_service_outlined ),
            activeIcon: Icon( Icons.room_service ),
            label: "Servicio",
          ), 
          BottomNavigationBarItem(
            icon: Icon( Icons.home_outlined ),
            activeIcon: Icon( Icons.home ),
            label: "Home",
          ),
          BottomNavigationBarItem(
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
      case 0: return context.go('/servicio');
      case 1: return context.go('/home');
      case 2: return context.go('/cuenta');
      default: return context.go('/servicio');
    }
  }
}
