import 'package:beans_driver_flutter/src/modelos/conecta_sql.dart';

class Persona {
  
  ConectaSQL con = ConectaSQL();

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
    
    Map<String, dynamic> res = await con.post(path: 'persona/nuevo', params: {
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


}