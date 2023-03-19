import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ConectaSQL {

  final String _destino = '10.0.2.2';
  final String _camino = 'flutter-ubicaciones-test';

  Future<dynamic> get( Map<String, String> params ) async {

    var url = Uri.http(_destino, _camino, params);
    
    log("Enviando: ${ url.toString() }");
    http.Response respuesta = await http.get( url );

    var json = jsonDecode( respuesta.body );

    log("Enviado existosamente");
    return json['_'];
  }
  
}