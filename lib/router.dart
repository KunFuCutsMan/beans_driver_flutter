import 'package:beans_driver_flutter/src/casos/cuenta/view_cuenta_usuario.dart';
import 'package:beans_driver_flutter/src/casos/home/pantalla_home.dart';
import 'package:beans_driver_flutter/src/casos/login/pantalla_login.dart';
import 'package:beans_driver_flutter/src/casos/menu/menu_cliente.dart';
import 'package:beans_driver_flutter/src/casos/registro/pantalla_registro.dart';
import 'package:beans_driver_flutter/src/casos/servicio/view_llama_servicio.dart';
import 'package:beans_driver_flutter/src/casos/servicio/view_sirve_servicio.dart';
import 'package:beans_driver_flutter/src/comun/pantalla_mapa_servicio.dart';
import 'package:beans_driver_flutter/src/modelos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerBeansDriver = GoRouter(
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
          return '/home/${res['_']['rolUsuarioID']}/${res['_']['usuarioID']}';
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
          path: '/servicio/:rolUsuario/:personaID/:usuarioID',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            // Reemplaza un body aquí
            if ( int.parse( state.pathParameters['rolUsuario']! ) == 1 ) {
              return ViewLlamaServicio(
                personaID: int.parse( state.pathParameters['personaID']! ),
                usuarioID: int.parse( state.pathParameters['usuarioID']! ),
              );
            }
            else if ( int.parse( state.pathParameters['rolUsuario']! ) == 2 ) {
              return ViewSirveServicio(
                usuarioID: int.parse( state.pathParameters['usuarioID']! ),
              );
            }
            
            return const Center( child: Text("Servicio"), );
          },
        ),
        
        GoRoute(
          path: '/home/:rolUsuarioID/:usuarioID',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            return PantallaHome(
              rolUsuarioID: int.parse(state.pathParameters['rolUsuarioID']!),
              usuarioID: int.parse(state.pathParameters['usuarioID']!),
            );
          },
        ),
        
        GoRoute(
          path: '/cuenta/:usuarioID/:personaID',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            return ViewCuentaUsuario(
              personaID: int.parse(state.pathParameters['personaID']!),
              usuarioID: int.parse(state.pathParameters['usuarioID']!),
            );
          },
        ),
      ],
    ),

    GoRoute(
      path: '/mapa/:servicioID',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        return PantallaMapaServicio(
          servicioID: int.parse(state.pathParameters['servicioID']!),
        );
      },
    ),
  ],
);
