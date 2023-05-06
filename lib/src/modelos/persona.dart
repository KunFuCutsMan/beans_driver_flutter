import 'package:beans_driver_flutter/src/modelos/conecta_sql.dart';

class Persona {
  
  final ConectaSQL _con = ConectaSQL();

  int personaID = 0;

  // Datos de ubicación
  int? estadoID = 1;
  int? municipioID = 1;
  int? localidadID = 1;

  // Datos personales
  String? nombre = '';
  String? apePrimero = '';
  String? apeSegundo = '';
  String? genero = '';
  String? numTel = '';

  Persona({
    required this.personaID,
    this.estadoID,
    this.municipioID,
    this.localidadID,
    this.nombre,
    this.apePrimero,
    this.apeSegundo,
    this.genero,
    this.numTel
  });

  Future< Map<String, dynamic> > insertaEnDB() async {
    
    Map<String, dynamic> res = await _con.post(path: 'persona/nuevo', params: {
      "nombre": "$nombre",
      "apePrimero": "$apePrimero",
      "apeSegundo": "$apeSegundo",
      "genero": "$genero",
      "numTel": "$numTel",
      "estadoID": "$estadoID",
      "municipioID": "$municipioID",
      "localidadID": "$localidadID",
    });

    return res;
  }

  Future<void> obtenPersonaEnDB() async {
    Map<String, dynamic> res = await _con.get(path: 'persona/datos', params: {
      "personaID": "$personaID",
    });

    if ( res['stat'] != 200 ) {
      return;
    }

    nombre = res['_']['nombre'];
    apePrimero = res['_']['apellido_1'];
    apeSegundo = res['_']['apellido_2'];
    genero = res['_']['genero'];
    numTel = res['_']['telefono'];
    estadoID = int.parse( res['_']['estadoID'] );
    municipioID = int.parse( res['_']['municipioID'] );
    localidadID = int.parse( res['_']['localidadID'] );
  }

  Future< Map<String, dynamic> > editaEnDB() async {
    
    Map<String, dynamic> res = await _con.post(path: 'persona/edita', params: {
      "personaID": "$personaID",
      "nombre": "$nombre",
      "apePrimero": "$apePrimero",
      "apeSegundo": "$apeSegundo",
      "genero": "$genero",
      "numTel": "$numTel",
      "estadoID": "$estadoID",
      "municipioID": "$municipioID",
      "localidadID": "$localidadID",
    });

    return res;
  }

  @override
  String toString() {
    return "Persona: personaID: $personaID, nombre: $nombre, apePrimero: $apePrimero,"
    " apeSegundo: $apeSegundo, genero: $genero, numTel: $numTel,"
    " estadoID: $estadoID, municipioID: $municipioID, localidadID: $localidadID";
  }


}