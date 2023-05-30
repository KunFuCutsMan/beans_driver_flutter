import 'package:beans_driver_flutter/router.dart';
import 'package:beans_driver_flutter/temas.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BeansDriver());
}

class BeansDriver extends StatefulWidget {
  const BeansDriver({super.key});

  @override
  State<BeansDriver> createState() => _BeansDriverState();

  // ignore: library_private_types_in_public_api
  static _BeansDriverState of(BuildContext context) =>
    context.findAncestorStateOfType<_BeansDriverState>()!;
}

class _BeansDriverState extends State<BeansDriver> {

  ThemeMode _tema = ThemeMode.system;

  void changeTheme(ThemeMode themeMode) {
    setState(() { _tema = themeMode; });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Beans Driver",
      debugShowCheckedModeBanner: false,

      theme: Temas.temaClaro,
      darkTheme: Temas.temaOscuro,
      themeMode: _tema,

      routerConfig: routerBeansDriver,
    );
  }
}
