import 'package:beans_driver_flutter/src/modelos/usuario.dart';

class Cliente extends Usuario {

  int? clienteID = 0;
  
  Cliente({
    required super.usuarioID,
    this.clienteID,
    super.contrasena,
    super.correo,
    super.personaID,
    super.rolUsuarioID,
    super.status,
  });

  Future<void> obtenClienteEnDB() async {
    Map<String, dynamic> res = await con.get(path: 'cliente/datos', params: {
      "usuarioID": "$usuarioID",
    });

    if ( res['stat'] != 200 ) {
      return;
    }

    clienteID = int.parse(res['_']['clienteID']);
  }

  Future< Map<String, dynamic> > tieneServicio() async {
    Map<String, dynamic> res = await con.get(path: 'servicio/status', params: {

    });

    return res;
  }

  Future< Map<String, dynamic> > obtenServicioActual() async {
    Map<String, dynamic> res = await con.get(path: 'servicio/status', params: {

    });

    return res;
  }

  Future< Map<String, dynamic> > cancelaServicio() async {
    Map<String, dynamic> res = await con.get(path: 'servicio/status', params: {

    });

    return res;
  }

  Future< Map<String, dynamic> > terminaServicio() async {
    Map<String, dynamic> res = await con.get(path: 'servicio/status', params: {

    });

    return res;
  }
  
}