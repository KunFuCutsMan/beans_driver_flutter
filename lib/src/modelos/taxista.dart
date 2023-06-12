import 'package:beans_driver_flutter/src/modelos/usuario.dart';

class Taxista extends Usuario {

  int? taxistaID = 0;

  Taxista({
    required super.usuarioID,
    this.taxistaID,
    super.contrasena,
    super.correo,
    super.personaID,
    super.rolUsuarioID,
    super.status,
  });

  @override
  Future<void> obtenUsuarioEnDB() async {
    await super.obtenUsuarioEnDB();
    await obtenTaxistaEnDB();
  }

  Future<void> obtenTaxistaEnDB() async {
    Map<String, dynamic> res = await con.get(path: 'taxista/datos', params: {
      "usuarioID": "$usuarioID",
    });

    if ( res['stat'] != 200 ) {
      return;
    }

    taxistaID = int.parse(res['_']['taxistaID']);
  }

  Future< Map<String, dynamic> > tieneServicio() async {
    Map<String, dynamic> res = await con.get(path: 'servicio/actual', params: {
      'taxistaID': '$taxistaID',
    });

    return res;
  }

  @override
  Future< Map<String, dynamic> > obtenServicioActual() async {
    Map<String, dynamic> res = await con.get(path: 'servicio/actual', params: {
      'taxistaID': '$taxistaID'
    });

    return res;
  }

  @override
  String toString() {
    return "Taxista: TaxistaID: $taxistaID, ${super.toString()}";
  }
  
}