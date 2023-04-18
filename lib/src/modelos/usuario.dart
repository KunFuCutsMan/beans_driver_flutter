import 'package:beans_driver_flutter/src/modelos/conecta_sql.dart';

class Usuario {

  ConectaSQL con = ConectaSQL();

  // Datos de usuario
  int usuarioID = 0;
  String? correo = '';
  String? contrasena = '';
  String? fechaRegistro = '';
  String? fechaSesion = '';
  int? status = 0;
  int? rolUsuarioID = 0;
  int? personaID = 0;

  Usuario({
    required this.usuarioID,
    this.correo,
    this.contrasena,
    this.rolUsuarioID,
    this.status,
    this.personaID,
  });

  Future< Map<String, dynamic> > insertaEnDB() async {
    
    Map<String, dynamic> res = await con.post(path: 'usuario/nuevo', params: {
      "correo": "$correo",
      "contrasena": "$contrasena",
      "tipoUsuarioID": "$rolUsuarioID",
      "personaID": "$personaID",
    });

    return res;
  }

  Future< Map<String, dynamic> > enviaCorreoActivacion() async {

    Map<String, dynamic> res = await con.post(path: 'usuario/confirma', params: {
      "usuarioID": "$usuarioID",
      "correo": "$correo",
      "contrasena": "$contrasena",
    });

    return res;
  }

  Future< Map<String, dynamic> > validaLogin() async {
    
    Map<String, dynamic> res = await con.post(path: 'usuario/login', params: {
      "correo": "$correo",
      "contrasena": "$contrasena",
    });

    return res;
  } 

  Future<void> obtenUsuarioEnDB() async {
    Map<String, dynamic> res = await con.get(path: 'usuario/datos', params: {
      "usuarioID": "$usuarioID",
    });

    if ( res['stat'] != 200 ) {
      return;
    }

    correo = res['_']['correo'];
    contrasena = res['_']['contrasena'];
    fechaRegistro = res['_']['fechaRegistro'];
    fechaSesion = res['_']['fechaSesion'];
    status = int.parse( res['_']['status'] );
    rolUsuarioID = int.parse( res['_']['rolUsuarioID'] );
    personaID = int.parse( res['_']['personaID'] );
  }
}