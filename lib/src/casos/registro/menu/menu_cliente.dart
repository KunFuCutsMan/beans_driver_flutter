import 'package:beans_driver_flutter/src/casos/registro/menu/menu_cliente_primera_vista.dart';
import 'package:beans_driver_flutter/src/casos/registro/menu/menu_cliente_solicitar_servicio.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
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
