import 'dart:developer';

import 'package:beans_driver_flutter/src/modelos/conecta_sql.dart';
import 'package:beans_driver_flutter/src/modelos/persona.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TabDatosUbicacion extends StatefulWidget {
  
  final Persona per;
  const TabDatosUbicacion({super.key, required this.per});

  @override
  State<TabDatosUbicacion> createState() => _TabDatosUbicacionState();
}

class _TabDatosUbicacionState extends State<TabDatosUbicacion> {

  late GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  // Las listas iniciales se generan en el initState()
  late List<dynamic> _listaEstados;
  late List<dynamic> _listaMunicipios;
  late List<dynamic> _listaLocalidades;

  int _idxEstadoActual = 1;
  int _idxMunicipioActual = 1;
  int _idxLocalidadActual = 1;

  final ConectaSQL con = ConectaSQL();

  // Método de validación
  void _validaFormulario( GlobalKey<FormBuilderState> formKey ) async {
    formKey.currentState?.save();

    log("ESTADO: $_idxEstadoActual");
    log("MUNICIPIO: $_idxMunicipioActual");
    log("LOCALIDAD: $_idxLocalidadActual");
    log("VALOR ESTADO: ${formKey.currentState?.value['estadoID']}");
    log("VALOR MUNIC: ${formKey.currentState?.value['municipioID']}");
    log("VALOR LOCAL: ${formKey.currentState?.value['localidadID']}");
  }

  @override
  void initState() {
    super.initState();

    // Nuestras llaves y listas iniciales tendrán un espacio vacío
    _idxEstadoActual = widget.per.estadoID ?? 1;
    _idxMunicipioActual = widget.per.municipioID ?? 1;
    _idxLocalidadActual = widget.per.localidadID ?? 1;

    _listaEstados = [ { 'idestados': "$_idxEstadoActual", 'Nombre': '...' } ];
    _listaMunicipios = [ { 'idmunicipios': "$_idxMunicipioActual", 'Nombre': '...' } ];
    _listaLocalidades = [ { 'idlocalidades': "$_idxLocalidadActual", 'Nombre': '...' } ];

    // Después de meter el widget al arbol de widgets
    // Vamos a obtener de manera asincrona los verdaderos valores
    () async {
      var resultados = await Future.wait([
        con.get(path: 'ubicaciones', params: {'e': '0'}),
        con.get(path: 'ubicaciones', params: {'e': "${widget.per.estadoID ?? 1}", 'm': '0'}),
        con.get(path: 'ubicaciones', params: {'e': "${widget.per.estadoID ?? 1}", 'm': "${widget.per.municipioID ?? 1}", 'l': '0'})
      ]);

      // Y cuando terminemos asignemoslos a los dropdowns
      setState(() {
        _listaEstados = resultados[0]['_'];
        _listaMunicipios = resultados[1]['_'];
        _listaLocalidades = resultados[2]['_'];
      });
    } ();
  }

  void _getMunicipios({ e = 1 }) async {

    var resultados = await Future.wait([
        con.get(path: 'ubicaciones', params: {'e': '$_idxEstadoActual', 'm': '0'}),
        con.get(path: 'ubicaciones', params: {'e': '$_idxEstadoActual', 'm': '$_idxMunicipioActual', 'l': '0'})
    ]);

    setState(() {
      _idxEstadoActual = e;
      _idxMunicipioActual = 1;
      _idxLocalidadActual = 1;
      _listaMunicipios = resultados[0]['_'];
      _listaLocalidades = resultados[1]['_'];
    });
  }

  void _getLocalidades({ m = 1 }) async {

    _idxMunicipioActual = m;

    var resultado = await con.get(
      path: 'ubicaciones',
      params:{'e': '$_idxEstadoActual', 'm': '$_idxMunicipioActual', 'l': '0'}
      );

    setState(() {
      _idxMunicipioActual = m;
      _idxLocalidadActual = 1;
      _listaLocalidades = resultado['_'];
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( child: FormBuilder(
      key: formKey,
      onChanged: () => formKey.currentState?.save(),

      child: Wrap(
        runSpacing: 15,
        alignment: WrapAlignment.center,
        children: [
          FormBuilderDropdown<int>(
            name: 'estadoID',
            decoration: InputDecoration(
              label: const Text("Estado:"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
            items: _listaEstados.map( (e) =>
              DropdownMenuItem<int>(
                value: int.parse(e['idestados']),
                child: Text( e['Nombre'] ),
              )
            ).toList(),
            onChanged: (value) => _getMunicipios( e: value ),
            initialValue: _idxEstadoActual,
          ),

          FormBuilderDropdown<int>(
            name: 'municipioID',
            decoration: InputDecoration(
              label: const Text("Municipio:"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
            items: _listaMunicipios.map( (e) =>
              DropdownMenuItem<int>(
                value: int.parse(e['idmunicipios']),
                child: Text( e['Nombre'] )
              )
            ).toList(),
            onChanged: (value) => _getLocalidades( m: value ),
            initialValue: _idxMunicipioActual,
          ),

          FormBuilderDropdown<int>(
            name: 'localidadID',
            decoration: InputDecoration(
              label: const Text("Localidad:"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
            items: _listaLocalidades.map( (e) =>
              DropdownMenuItem<int>(
                value: int.parse(e['idlocalidades']),
                child: Text( e['Nombre'] ),
              )
            ).toList(),
            initialValue: _idxLocalidadActual,
          ),

          ElevatedButton(
            onPressed: () => _validaFormulario( formKey ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary
            ),
            child: Text("Editar", style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSecondary
            ), )
          ),
        ],
      ), ),
    );
  }
}