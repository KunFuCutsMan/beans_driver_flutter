import 'dart:developer';

import 'package:beans_driver_flutter/src/comun/dialogo_alerta.dart';
import 'package:beans_driver_flutter/src/modelos/cliente.dart';
import 'package:beans_driver_flutter/src/modelos/conecta_sql.dart';
import 'package:beans_driver_flutter/src/modelos/servicio.dart';
import 'package:beans_driver_flutter/src/modelos/taxista.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum VeTargetaComo {
  taxista,
  cliente,
  ninguno,
}

class TargetaServicio extends StatefulWidget {
  final int servicioID;
  final VeTargetaComo vista;
  final int? taxistaID;
  final int? clienteID;
  const TargetaServicio({
    super.key,
    required this.servicioID,
    required this.vista,
    this.taxistaID,
    this.clienteID,
  });

  @override
  State<TargetaServicio> createState() => _TargetaServicioState();
}

class _TargetaServicioState extends State<TargetaServicio> {

  late final Servicio serv;
  bool _isListo = false;

  @override
  void initState() {
    super.initState();
    serv = Servicio(servicioID: widget.servicioID);

    () async {
      await serv.obtenServicioEnDB();
      log(serv.toString());
      setState(() { _isListo = true; });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
      
            _isListo ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(tipoServicio(serv.tipoServicioID!), style: Theme.of(context).textTheme.labelLarge),
                Text(fechaServicio(serv.fecha!), style: Theme.of(context).textTheme.labelLarge),
                Text(horaServicio(serv.hora!), style: Theme.of(context).textTheme.labelLarge),
              ],
            ) : const Text(""),

            _isListo ? UbicacionTexto(serv: serv) : const Text(""),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary
                  ),
                  onPressed: () => context.push('/mapa/${widget.servicioID}'),
                  child: const Text("Ubicación"),
                ),

                if ( widget.vista == VeTargetaComo.cliente )
                  ...botonesCliente(),
                
                if ( widget.vista == VeTargetaComo.taxista )
                  ...botonesTaxista(),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> botonesCliente() => [
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary
      ),
      onPressed: _terminaServicio,
      child: const Text("Terminar")
    ),
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary
      ),
      onPressed: _cancelaServicio,
      child: const Text("Cancelar")
    ),
  ];

  List<Widget> botonesTaxista() => [
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary
      ),
      onPressed: _asignaServicioATaxista,
      child: const Text("Escoger")
    ),
  ];

  String tipoServicio(int tipoServicioID) => tipoServicioID == 1
      ? "Normal"
      : tipoServicioID == 2
        ? "Recurrente" : "";

  String fechaServicio(DateTime t) => "${t.day}-${t.month}-${t.year}";

  String horaServicio(DateTime h) {
    String minuto = h.minute < 9
      ? "0${h.minute}"
      : "${h.minute}";
    return "${h.hour}:$minuto";
  }


  void _asignaServicioATaxista() async {

    Taxista tax = Taxista( usuarioID: 0, taxistaID: widget.taxistaID!);
    Map<String, dynamic> tieneServicio = await tax.tieneServicio();

    if ( !tieneServicio['_']['tieneServicio'] ) {
      serv.taxistaID = widget.taxistaID!;
      Map<String, dynamic> res = await serv.asignaTaxista();
      
      if ( res['stat'] == 200 && res['_'] ) {
        // ignore: use_build_context_synchronously
        DialogoAlerta.avisaInfo(context, 'Se asignó el servicio con éxito');
      } else {
        // ignore: use_build_context_synchronously
        DialogoAlerta.avisaInfo(context, 'Hubo un error al asignar el servicio: ${res['error']}');
      }
    }
    else {
      // ignore: use_build_context_synchronously
      DialogoAlerta.avisaInfo(context, 'Ya tiene un servicio asignado');
    }

    
  }

  void _terminaServicio() async {
    Cliente cli = Cliente(usuarioID: 0, clienteID: widget.clienteID!);
    Map<String, dynamic> tieneServicio = await cli.tieneServicio();

    if ( tieneServicio['_']['tieneServicio'] ) {
      Map<String, dynamic> res = await cli.terminaServicio( serv.servicioID );
      
      if ( res['stat'] == 200 && res['_'] ) {
        // ignore: use_build_context_synchronously
        DialogoAlerta.avisaInfo(context, 'Se terminó el servicio con éxito');
      } else {
        // ignore: use_build_context_synchronously
        DialogoAlerta.avisaInfo(context, 'Hubo un error al terminar el servicio: ${res['error']}');
      }
    }
    else {
      // ignore: use_build_context_synchronously
      DialogoAlerta.avisaInfo(context, 'Ya tiene un servicio asignado');
    }
  }

  void _cancelaServicio() async {
    Cliente cli = Cliente(usuarioID: 0, clienteID: widget.clienteID!);
    Map<String, dynamic> tieneServicio = await cli.tieneServicio();

    if ( tieneServicio['_']['tieneServicio'] ) {
      Map<String, dynamic> res = await cli.cancelaServicio( serv.servicioID );
      
      if ( res['stat'] == 200 && res['_'] ) {
        // ignore: use_build_context_synchronously
        DialogoAlerta.avisaInfo(context, 'Se canceló el servicio con éxito');
      } else {
        // ignore: use_build_context_synchronously
        DialogoAlerta.avisaInfo(context, 'Hubo un error al cancelar el servicio: ${res['error']}');
      }
    }
    else {
      // ignore: use_build_context_synchronously
      DialogoAlerta.avisaInfo(context, 'Ya tiene un servicio asignado');
    }
  }
}

class UbicacionTexto extends StatefulWidget {
  final Servicio serv;
  const UbicacionTexto({super.key, required this.serv});

  @override
  State<UbicacionTexto> createState() => _UbicacionTextoState();
}

class _UbicacionTextoState extends State<UbicacionTexto> {

  String estadoFinal = "";
  String muniFinal = "";
  String localFinal = "";

  String estadoInicial = "";
  String muniInicial = "";
  String localInicial = "";

  @override
  void initState() {
    super.initState();

    () async {
      ConectaSQL con = ConectaSQL();

      String edoIni = "${widget.serv.estadoInicialID}";
      String munIni = "${widget.serv.municipioInicialID}";
      String locIni = "${widget.serv.localidadInicialID}";
      String edoFin = "${widget.serv.estadoFinalID}";
      String munFin = "${widget.serv.municipioFinalID}";
      String locFin = "${widget.serv.localidadFinalID}";

      // Obten los nombres de las localidades
      List res = await Future.wait([
        con.get(path: "ubicaciones", params: { 'e': edoIni, }),
        con.get(path: "ubicaciones", params: { 'e': edoIni, 'm': munIni }),
        con.get(path: "ubicaciones", params: { 'e': edoIni, 'm': munIni, 'l': locIni }),
        con.get(path: "ubicaciones", params: { 'e': edoFin }),
        con.get(path: "ubicaciones", params: { 'e': edoFin, 'm': munFin }),
        con.get(path: "ubicaciones", params: { 'e': edoFin, 'm': munFin, 'l': locFin }),
      ]);

      setState(() {
        estadoInicial = res[0]['_'][0]['Nombre'].toString();
        muniInicial = res[1]['_'][0]['Nombre'].toString();
        localInicial = res[2]['_'][0]['Nombre'].toString();
        estadoFinal = res[3]['_'][0]['Nombre'].toString();
        muniFinal = res[4]['_'][0]['Nombre'].toString();
        localFinal = res[5]['_'][0]['Nombre'].toString();
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Ubicacion inicial
        Column(
          children: [
            Text("Ubicación Inicial:", style: Theme.of(context).textTheme.titleSmall),
            Text(estadoInicial),
            Text(muniInicial),
            Text(localInicial),
          ],
        ),

        // Ubicacion final
        Column(
          children: [
            Text("Ubicación Final:", style: Theme.of(context).textTheme.titleSmall),
            Text(estadoFinal),
            Text(muniFinal),
            Text(localFinal),
          ],
        ),
      ],
    );
  }
}