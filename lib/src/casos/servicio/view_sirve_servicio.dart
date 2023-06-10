import 'package:beans_driver_flutter/src/comun/targeta_servicio.dart';
import 'package:beans_driver_flutter/src/modelos/servicio.dart';
import 'package:beans_driver_flutter/src/modelos/taxista.dart';
import 'package:flutter/material.dart';

class ViewSirveServicio extends StatefulWidget {
  final int usuarioID;
  const ViewSirveServicio({super.key, required this.usuarioID});

  @override
  State<ViewSirveServicio> createState() => _ViewSirveServicioState();
}

class _ViewSirveServicioState extends State<ViewSirveServicio> {

  late List<dynamic> servicioListas;
  late int taxistaID = 0;

  @override
  void initState() {
    super.initState();
    servicioListas = [];

    () async {
      Servicio serv = Servicio(servicioID: 0);
      Taxista tax = Taxista(usuarioID: widget.usuarioID);
      
      List<dynamic> res = await Future.wait([
        serv.obtenServiciosDisponibles(),
        tax.obtenTaxistaEnDB(),
      ]);

      setState(() {
        servicioListas = res[0]['_'];
        taxistaID = tax.taxistaID!;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: servicioListas.length,
      itemBuilder: (BuildContext context, int index) =>
        TargetaServicio(
          servicioID: int.parse(servicioListas[index]['idservicio']),
          vista: VeTargetaComo.taxista,
          taxistaID: taxistaID,
        ),
    );
  }
}