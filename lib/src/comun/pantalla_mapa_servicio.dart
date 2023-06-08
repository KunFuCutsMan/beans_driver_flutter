import 'package:beans_driver_flutter/src/comun/app_barra.dart';
import 'package:beans_driver_flutter/src/modelos/conecta_sql.dart';
import 'package:beans_driver_flutter/src/modelos/servicio.dart';
import 'package:flutter/material.dart';

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
      'inicial': res[0],
      'final': res[1],
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
              return const Text("MAPA AQUÍ");
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