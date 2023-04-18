import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ConectaSQL {

  final String _destino = '10.0.2.2';
  final String _camino = 'beans-driver-backend';

  ConectaSQL();

  Future<dynamic> get({required String path ,required Map<String, String> params}) async {

    var url = Uri.http(_destino, "$_camino/$path", params);
    
    log("Enviando: ${ url.toString() }");
    http.Response respuesta = await http.get( url );

    var json = jsonDecode( respuesta.body );

    log("Enviado existosamente: ${ respuesta.body }");
    return json;
  }

  Future<dynamic> post({required String path ,required Map<String, String> params}) async {

    var url = Uri.http(_destino, "$_camino/$path/" );
    log("Enviando a: ${ url.toString() }");
    http.Response respuesta = await http.post( url, body: params );

    var json = jsonDecode( respuesta.body );

    log("Enviado exitosamente: ${ respuesta.body }");
    return json;
  }
  
}