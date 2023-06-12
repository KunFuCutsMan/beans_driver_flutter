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

  @override
  Future<void> obtenUsuarioEnDB() async {
    await super.obtenUsuarioEnDB();
    await obtenClienteEnDB();
  }

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
    Map<String, dynamic> res = await con.get(path: 'servicio/actual', params: {
      'clienteID': '$clienteID',
    });

    return res;
  }

  @override
  Future< Map<String, dynamic> > obtenServicioActual() async {
    Map<String, dynamic> res = await con.get(path: 'servicio/actual', params: {
      'clienteID': '$clienteID'
    });

    return res;
  }

  Future< Map<String, dynamic> > cancelaServicio(int servicioID) async {
    Map<String, dynamic> res = await con.get(path: 'servicio/cancela', params: {
      'clienteID': '$clienteID',
      'servicioID': '$servicioID',
    });

    return res;
  }

  Future< Map<String, dynamic> > terminaServicio(int servicioID) async {
    Map<String, dynamic> res = await con.get(path: 'servicio/termina', params: {
      'clienteID': '$clienteID',
      'servicioID': '$servicioID',
    });

    return res;
  }

  @override
  String toString() {
    return "Cliente: clienteID: $clienteID, ${super.toString()}";
  }
  
}