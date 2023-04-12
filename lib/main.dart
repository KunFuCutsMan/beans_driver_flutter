import 'package:beans_driver_flutter/src/casos/login/pantalla_login.dart';
import 'package:beans_driver_flutter/src/casos/registro/menu/menu_cliente.dart';
import 'package:beans_driver_flutter/src/casos/registro/pantalla_registro.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    
    GoRoute(
      path: '/login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => PantallaLogin(),
      
      // ¿Está logeado el usuario?
      redirect: (context, state) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        if ( prefs.getBool("usuarioTieneLogin") ?? false ) {
          return '/home';
        } else {
          await prefs.setBool("usuarioTieneLogin", false);
          return null;
        }
      },
    ),
    
    GoRoute(
      path: '/registro',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => PantallaRegistro(),
    ),
    
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) => NoTransitionPage(
        child: Menu(cuerpo: child),
      ),
      routes: <RouteBase>[
        
        // Actua como un router normal, pero ahora sirver para el bottomNavigationBar
        GoRoute(
          path: '/servicio',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            // Reemplaza un body aquí
            return const Center( child: Text("Servicio") );
          },
        ),
        
        GoRoute(
          path: '/home',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            // Reemplaza un body aquí
            return const Center( child: Text("Home") );
          },
        ),
        
        GoRoute(
          path: '/cuenta',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            // Reemplaza un body aquí
            return const Center( child: Text("Cuenta") );
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Beans Driver",
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF00CC66),
          onPrimary: Colors.white,
          secondary: Color(0xFFCED45E),
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.black,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Color(0xFFFFFFC0),
          onSurface: Colors.black,
        ),
      ),

      routerConfig: _router,
    );
  }
}
