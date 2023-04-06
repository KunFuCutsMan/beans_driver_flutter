import 'package:beans_driver_flutter/src/casos/registro/menu/menu_cliente_primera_vista.dart';
import 'package:beans_driver_flutter/src/casos/registro/menu/menu_cliente_solicitar_servicio.dart';
import 'package:beans_driver_flutter/src/comun/drawer_usuario.dart';
import 'package:flutter/material.dart';



class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _currenIndex = 0;
  final List<Widget> children = [
    const PrimeraVista(),
    const SegundaVista(),
  ];
  void onTappedBar(int index) {
    setState(() {
      _currenIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text("Beans Driver"), ),
      drawer: const DrawerUsuario(),
      body: children[_currenIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 16.0,
        selectedItemColor: Colors.black,
        onTap: onTappedBar,
        currentIndex: _currenIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_max_outlined), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.room_service), label: "Servicio"),
        ],
      ),
    );
  }
}
