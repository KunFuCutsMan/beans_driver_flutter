import 'package:beans_driver_flutter/src/casos/cuenta/view_cuenta_usuario.dart';
import 'package:beans_driver_flutter/src/casos/login/pantalla_login.dart';
import 'package:beans_driver_flutter/src/casos/menu/menu_cliente.dart';
import 'package:beans_driver_flutter/src/casos/registro/pantalla_registro.dart';
import 'package:beans_driver_flutter/src/modelos/usuario.dart';
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
  routes: [
    
    GoRoute(
      path: '/',
      // ¿Está logeado el usuario?
      redirect: (context, state) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        Usuario usu = Usuario(usuarioID: 0);
        usu.correo = prefs.getString("usuarioCorreo") ?? "";
        usu.contrasena = prefs.getString("usuarioContra") ?? "";
        bool? usuTieneLogin = prefs.getBool("usuarioTieneLogin") ?? false;

        Map<String, dynamic> res = await usu.validaLogin();        

        // Si se pudo hacer el login
        if ( res['stat'] == 200 && usuTieneLogin && res['_']['loginValido'] == true ) {

          // Establece la ID del usuario
          await prefs.setInt("usuarioID", int.parse(res['_']['usuarioID']));

          // Ve al menu principal
          return '/home';
        } else {
          // En cambio, borra los datos de login y regresa a la pantalla login
          await Future.wait([
            prefs.setBool("usuarioTieneLogin", false),
            prefs.setString("usuarioCorreo", ""),
            prefs.setString("usuarioContra", ""),
            prefs.setInt("usuarioID", 0 ),
          ]);
          return '/login';
        }
      },
    ),
    GoRoute(
      path: '/login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => PantallaLogin(),
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
            return const ViewCuentaUsuario();
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
