import 'dart:developer';

import 'package:beans_driver_flutter/src/comun/app_barra.dart';
import 'package:beans_driver_flutter/src/modelos/conecta_sql.dart';
import 'package:beans_driver_flutter/src/modelos/servicio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PantallaMapaServicio extends StatefulWidget {
  final int servicioID;
  const PantallaMapaServicio({super.key, required this.servicioID});

  @override
  State<PantallaMapaServicio> createState() => _PantallaMapaServicioState();
}

class _PantallaMapaServicioState extends State<PantallaMapaServicio> {

  late final Servicio serv;
  late Future< Map<String, dynamic> > _isListo;

  Future< Map<String, dynamic> > _obtenServicioInfo() async {
    // Obten la información del servicio
    final Servicio serv = Servicio(servicioID: widget.servicioID);
    await serv.obtenServicioEnDB();

    // Obten las ubicaciones
    final ConectaSQL con = ConectaSQL();
    List res = await Future.wait([
      con.get(path: 'ubicaciones', params: { 'e': '${serv.estadoInicialID}', 'm': '${serv.municipioInicialID}', 'l': '${serv.localidadInicialID}' }),
      con.get(path: 'ubicaciones', params: { 'e': '${serv.estadoFinalID}', 'm': '${serv.municipioFinalID}', 'l': '${serv.localidadFinalID}' }),
    ]);

    return {
      'inicial': res[0]['_'][0],
      'final': res[1]['_'][0],
    };
  }

  @override
  void initState() {
    super.initState();
    serv = Servicio(servicioID: widget.servicioID);
    _isListo = _obtenServicioInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarra(),
      body: FutureBuilder(
        future: _isListo,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if ( snapshot.connectionState == ConnectionState.waiting ) {
            return const Center(child: CircularProgressIndicator());
          } else if ( snapshot.connectionState == ConnectionState.done ) {
            // Checa si hay error
            if ( snapshot.hasError ) {
              return ErrorWidget( snapshot.error! );
            }
            else if ( snapshot.hasData ) {
              log("> ${snapshot.data}");
              return MapaServicio(
                ubicacionInicial: snapshot.data['inicial'],
                ubicacionFinal: snapshot.data['final'],
              );
            }
            else {
              return const Text("what");
            }
          }
          else {
            return Text('${snapshot.connectionState}');
          }
        },
      ),
    );
  }
}

class MapaServicio extends StatelessWidget {

  final Map<String, dynamic> ubicacionInicial;
  final Map<String, dynamic> ubicacionFinal;
  const MapaServicio({super.key, required this.ubicacionInicial, required this.ubicacionFinal});

  String format( String s ) => s
    .replaceAll( RegExp(" ") , '" ')
    .replaceAll( RegExp("°") , "° ")
    .replaceAll( RegExp("´"), "' ");

  @override
  Widget build(BuildContext context) {
    String latIni = format(ubicacionInicial['Latitud']);
    String lngIni = format(ubicacionInicial['Longitud']);
    String latFin = format(ubicacionFinal['Latitud']);
    String lngFin = format(ubicacionFinal['Longitud']);
      
    final LatLng posicionIni = LatLng.fromSexagesimal("$latIni, $lngIni");
    final LatLng posicionFin = LatLng.fromSexagesimal("$latFin, $lngFin");
    
    return FlutterMap(
      options: MapOptions(
        minZoom: 5,
        maxZoom: 25,
        zoom: 14,
        center: posicionIni,
      ),
      nonRotatedChildren: [
        TileLayer(
          urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={token}',
          additionalOptions: {
            'token': "${dotenv.env['MAPBOX_TOKEN']}",
            'id': 'mapbox/streets-v12',
          },
        ),
        MarkerLayer(
          markers: [
            Marker(point: posicionIni,
              builder: (context) => const Icon(
                Icons.location_on,
                size: 60,
              ),
            ),
            Marker(
              point: posicionFin,
              builder: (context) => const Icon(
                Icons.location_on,
                size: 60,
              ),
            ),
          ],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: [
                posicionIni,
                posicionFin
              ],
              color: Colors.black,
              strokeWidth: 4,
            ),
          ],
        ),
      ],
    );
  }
}