import 'package:beans_driver_flutter/src/modelos/conecta_sql.dart';

class Servicio {
  
  final ConectaSQL _con = ConectaSQL();

  int servicioID = 0;

  DateTime? fecha;
  DateTime? hora;
  String? detalles = '';
  int? tipoServicioID = 0;
  int? statusServicioID = 0;
  int? clienteID = 0;
  int? taxistaID = 0;

  String? calleInicial = '';
  int? localidadInicialID = 0;
  int? municipioInicialID = 0;
  int? estadoInicialID = 0;

  String? calleFinal = '';
  int? localidadFinalID = 0;
  int? municipioFinalID = 0;
  int? estadoFinalID = 0;

  Servicio({
    required this.servicioID,
    this.fecha,
    this.hora,
    this.detalles,
    this.tipoServicioID,
    this.statusServicioID,
    this.clienteID,
    this.taxistaID,
    this.calleInicial,
    this.localidadInicialID,
    this.municipioInicialID,
    this.estadoInicialID,
    this.calleFinal,
    this.localidadFinalID,
    this.municipioFinalID,
    this.estadoFinalID,
  });

  Future<void> obtenServicioEnDB() async {

    Map<String, dynamic> res = await _con.get(path: "servicio/datos", params: {
      'servicioID': "$servicioID",
    });

    fecha = DateTime.parse(res['_']['Fecha']);
    hora = DateTime.parse("0000-00-00 ${res['_']['Hora']}");
    tipoServicioID = int.parse( res['_']['idtipo-servicio'] );
    statusServicioID = int.parse( res['_']['idstatus-servicio'] );
    detalles = res['_']['Detalles'];
    clienteID = int.parse( res['_']['idcliente'] );
    taxistaID = int.tryParse( "${res['_']['idtaxista']}" );
    calleInicial = res['_']['CalleInicial'];
    estadoInicialID = int.parse( res['_']['idestado-Inicial'] );
    municipioInicialID = int.parse( res['_']['idmunicipio-Inicial'] );
    localidadInicialID = int.parse( res['_']['idlocalidad-Inicial'] );
    calleFinal = res['_']['CalleFinal'];
    estadoFinalID = int.parse( res['_']['idestado-Final'] );
    municipioFinalID = int.parse( res['_']['idmunicipio-Final'] );
    localidadFinalID = int.parse( res['_']['idlocalidad-Final'] );
  }

  Future< Map<String, dynamic> > insertaEnDB() async {
    Map<String, dynamic> res = await _con.post(path: "servicio/nuevo", params: {
      'fecha': "${fecha?.year}-${fecha?.month}-${fecha?.day}",
      'hora': "${hora?.hour}:${hora?.minute}:${hora?.second}",
      'tipo': "$tipoServicioID",
      'detalles': "$detalles",
      'clienteID': "$clienteID",
      'edoIni': "$estadoInicialID",
      'munIni': "$municipioInicialID",
      'locIni': "$localidadInicialID",
      'calIni': "$calleInicial",
      'edoFin': "$estadoFinalID",
      'munFin': "$municipioFinalID",
      'locFin': "$localidadFinalID",
      'calFin': "$calleFinal",
    });

    return res;
  }

  Future< Map<String, dynamic> > obtenServiciosDisponibles() async {
    Map<String, dynamic> res = await _con.post(path: 'servicio/datos', params: {
      'servicioID': '0',
    });

    return res;
  }

  Future< Map<String, dynamic> > editaEnDB() async {
    Map<String, dynamic> res = await _con.post(path: 'servicio/edita', params: {
      'servicioID': "$servicioID",
      'fecha': "${fecha?.year}-${fecha?.month}-${fecha?.day}",
      'hora': "${hora?.hour}:${hora?.minute}:${hora?.second}",
      'tipo': "$tipoServicioID",
      'status': "$statusServicioID",
      'detalles': "$detalles",
      'clienteID': "$clienteID",
      'taxistaID': "$taxistaID",
      'edoIni': "$estadoInicialID",
      'munIni': "$municipioInicialID",
      'locIni': "$localidadInicialID",
      'calIni': "$calleInicial",
      'edoFin': "$estadoFinalID",
      'munFin': "$municipioFinalID",
      'locFin': "$localidadFinalID",
      'calFin': "$calleFinal",
    });

    return res;
  }

  @override
  String toString() {
    return "Servicio: servicioID: $servicioID, fecha: $fecha, hora: $hora,"
    " detalles: $detalles, tipoServicioID: $tipoServicioID, statusServicioID: $statusServicioID,"
    " clienteID: $clienteID, taxistaID: $taxistaID, calleInicial: $calleInicial,"
    " localidadInicialID: $localidadInicialID, municipioInicialID: $municipioInicialID,"
    " estadoInicialID: $estadoInicialID, calleFinal: $calleFinal, localidadFinalID: $localidadFinalID,"
    " municipioInicialID: $municipioFinalID, estadoFinalID: $estadoFinalID";
  }

}