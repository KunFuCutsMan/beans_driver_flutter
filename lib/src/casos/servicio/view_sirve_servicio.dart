import 'package:beans_driver_flutter/src/comun/targeta_servicio.dart';
import 'package:beans_driver_flutter/src/modelos/servicio.dart';
import 'package:flutter/material.dart';

class ViewSirveServicio extends StatefulWidget {
  const ViewSirveServicio({super.key});

  @override
  State<ViewSirveServicio> createState() => _ViewSirveServicioState();
}

class _ViewSirveServicioState extends State<ViewSirveServicio> {

  late List<dynamic> servicioListas;

  @override
  void initState() {
    super.initState();
    servicioListas = [];

    () async {
      Servicio serv = Servicio(servicioID: 0);
      Map<String, dynamic> res = await serv.obtenServiciosDisponibles();

      setState(() { servicioListas = res['_']; });
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
        ),
    );
  }
}