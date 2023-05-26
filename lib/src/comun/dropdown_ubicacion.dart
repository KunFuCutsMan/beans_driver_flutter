import 'package:beans_driver_flutter/src/modelos/conecta_sql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// Widget que contiene tres [FormBuilderDropdown]s que preguntan una ubicación.
/// 
/// Se utiliza dentro de formularios cuando se requiera preguntar acerca sobre una
/// ubicación mediante el **estado**, **municipio** y **localidad**  de donde se
/// ubica. Cuando se selecciona un estado, los dropdowns de municipios y localidad
/// se actualizan acorde al estado seleccionado, y lo mismo ocurre con las localidades
/// cuando se selecciona un municipio
/// 
/// No contiene una llave de formulario, pero sí utiliza la librería [FormBuilderValidators]
/// como validador de sus dropdowns.
class DropdownUbicacion extends StatefulWidget {

  /// Nombre del dropdown encargado de preguntar acerca de los estados.
  final String estadoNombre;
  /// Nombre del dropdown encargado de preguntar acerca de los municipios.
  final String municipioNombre;
  /// Nombre del dropdown encargado de preguntar acerca de las localidades.
  final String localidadNombre;

  /// Decoración de cada dropdown. El parámetro ```label``` siempre será el nombre
  /// de lo que se pregunta. Ej: para el dropdown de municipios su label es "Municipio:"
  final InputDecoration? decoracion;
  /// ID del estado del cual inicia seleccionado su [FormBuilderDropdown].
  final int? estadoID;
  /// ID del municipio del cual inicia seleccionado su [FormBuilderDropdown].
  /// Depende de la ID de estados.
  final int? municipioID;
  /// ID de la localidad del cual inicia seleccionado su [FormBuilderDropdown].
  /// Depende de la ID de estados y municipios.
  final int? localidadID;

  const DropdownUbicacion({
    super.key,
    required this.estadoNombre,
    required this.municipioNombre,
    required this.localidadNombre,
    this.decoracion,
    this.estadoID,
    this.municipioID,
    this.localidadID,
  });

  @override
  State<DropdownUbicacion> createState() => _DropdownUbicacionState();
}

class _DropdownUbicacionState extends State<DropdownUbicacion> {
  
  // Las listas iniciales se generan en el initState()
  late List<dynamic> _listaEstados;
  late List<dynamic> _listaMunicipios;
  late List<dynamic> _listaLocalidades;

  int _idxEstadoActual = 1;
  int _idxMunicipioActual = 1;
  int _idxLocalidadActual = 1;

  final ConectaSQL con = ConectaSQL();

  void _getMunicipios({ e = 1 }) async {  

    _idxEstadoActual = e;

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
  void initState() {
    super.initState();

    // Nuestras llaves y listas iniciales tendrán un espacio vacío
    _idxEstadoActual = widget.estadoID ?? 1;
    _idxMunicipioActual = widget.municipioID ?? 1;
    _idxLocalidadActual = widget.localidadID ?? 1;

    _listaEstados = [ { 'idestados': "$_idxEstadoActual", 'Nombre': '...' } ];
    _listaMunicipios = [ { 'idmunicipios': "$_idxMunicipioActual", 'Nombre': '...' } ];
    _listaLocalidades = [ { 'idlocalidades': "$_idxLocalidadActual", 'Nombre': '...' } ];

    // Después de meter el widget al arbol de widgets
    // Vamos a obtener de manera asincrona los verdaderos valores
    () async {
      var resultados = await Future.wait([
        con.get(path: 'ubicaciones', params: {'e': '0'}),
        con.get(path: 'ubicaciones', params: {'e': '$_idxEstadoActual', 'm': '0'}),
        con.get(path: 'ubicaciones', params: {'e': '$_idxEstadoActual', 'm': '$_idxMunicipioActual', 'l': '0'})
      ]);

      // Y cuando terminemos asignemoslos a los dropdowns
      setState(() {
        _listaEstados = resultados[0]['_'];
        _listaMunicipios = resultados[1]['_'];
        _listaLocalidades = resultados[2]['_'];
      });
    } ();
  }
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 15,
      alignment: WrapAlignment.center,
      children: [
        // Dropdown de Estado
        FormBuilderDropdown<int>(
          name: widget.estadoNombre,
          
          decoration: widget.decoracion?.copyWith(
            label: const Text("Estado:")
          ) ?? const InputDecoration( label: Text("Estado:") ),

          items: _listaEstados.map( (e) =>
            DropdownMenuItem<int>(
              value: int.parse(e['idestados']),
              child: Text( e['Nombre'] ),
            )
          ).toList(),

          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Ingrese un estado"),
            FormBuilderValidators.min(1, errorText: "Ingrese un estado válido"),
          ]),

          onChanged: (value) => _getMunicipios( e: value ),
          initialValue: _idxEstadoActual,
        ),

        FormBuilderDropdown<int>(
          name: widget.municipioNombre,

          decoration: widget.decoracion?.copyWith(
            label: const Text("Municipio:")
          ) ?? const InputDecoration( label: Text("Municipio:") ),

          items: _listaMunicipios.map( (e) =>
            DropdownMenuItem<int>(
              value: int.parse(e['idmunicipios']),
              child: Text( e['Nombre'] )
            )
          ).toList(),

          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Ingrese un municipio"),
            FormBuilderValidators.min(1, errorText: "Ingrese un municipio válido"),
          ]),

          onChanged: (value) => _getLocalidades( m: value ),
          initialValue: _idxMunicipioActual,
        ),

        FormBuilderDropdown<int>(
          name: widget.localidadNombre,

          decoration: widget.decoracion?.copyWith(
            label: const Text("Localidad:")
          ) ?? const InputDecoration( label: Text("Localidad:") ),

          items: _listaLocalidades.map( (e) =>
            DropdownMenuItem<int>(
              value: int.parse(e['idlocalidades']),
              child: Text( e['Nombre'] ),
            )
          ).toList(),

          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Ingrese una localidad"),
            FormBuilderValidators.min(1, errorText: "Ingrese una localidad válida"),
          ]),
          
          initialValue: _idxLocalidadActual,
        ),
      ],
    );
  }
}