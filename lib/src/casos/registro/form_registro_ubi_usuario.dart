import 'dart:developer';

import 'package:beans_driver_flutter/src/modelos/conecta_sql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormRegUbicacionUsuario extends StatefulWidget {

  final GlobalKey<FormBuilderState> formKey;
  final void Function() resultado;

  final ConectaSQL con = ConectaSQL();

  FormRegUbicacionUsuario({super.key, required this.formKey, required this.resultado});

  @override
  State<FormRegUbicacionUsuario> createState() => _FormRegUbicacionUsuarioState();
}

class _FormRegUbicacionUsuarioState extends State<FormRegUbicacionUsuario> {

  // Las listas necesitan al menos un item para generar los form builders correctamente
  // Por lo que les vamos a proveer el mínimo hasta que se actualicen los resultados
  List<dynamic> listaEstados = const [ { 'idestados': '0', 'Nombre': '...' } ];
  List<dynamic> listaMunicipios = const [ { 'idmunicipios': '0', 'Nombre': '...' } ];
  List<dynamic> listaLocalidades = const [ { 'idlocalidades': '0', 'Nombre': '...' } ];

  int _idxEstadoActual = 1;
  int _idxMunicipioActual = 1;

  @override
  void initState() {
    super.initState();

    // Después de meter el widget al arbol de widgets
    // Vamos a obtener de manera asincrona los verdaderos valores
    () async {
      var resultados = await Future.wait([
        widget.con.get(path: 'ubicaciones', params: {'e': '0'}),
        widget.con.get(path: 'ubicaciones', params: {'e': '1', 'm': '0'}),
        widget.con.get(path: 'ubicaciones', params: {'e': '1', 'm': '1', 'l': '0'})
      ]);

      // Y cuando terminemos asignemoslos a los dropdowns
      setState(() {
        listaEstados = resultados[0];
        listaMunicipios = resultados[1];
        listaLocalidades = resultados[2];
      });
    } ();
  }

  void _getMunicipios({ e = 1 }) async {
    var resultados = await Future.wait([
        widget.con.get(path: 'ubicaciones', params: {'e': '$e', 'm': '0'}),
        widget.con.get(path: 'ubicaciones', params: {'e': '$e', 'm': '1', 'l': '0'})
    ]);

    setState(() {
      _idxEstadoActual = e;
      listaMunicipios = resultados[0];
    });
  }

  void _getLocalidades({ m = 1 }) async {
    _idxMunicipioActual = m;

    var resultado = await widget.con.get(
      path: 'ubicaciones',
      params:{'e': '$_idxEstadoActual', 'm': '$_idxMunicipioActual', 'l': '0'}
    );

    setState(() {
      _idxMunicipioActual = m;
      listaLocalidades = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        FormBuilder(
          key: widget.formKey,
          skipDisabled: true,
          onChanged: () => widget.formKey.currentState?.save(),
          child: Column(
            children: [
              const Text("¿Donde vives?"),

              // Estados
              FormBuilderDropdown<int>(
                name: 'ubi_estado',
                decoration: const InputDecoration( label: Text("Estado:"), ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "Seleccione su estado"),
                  FormBuilderValidators.min(1, errorText: "Ingrese un estado válido"),
                ]),
                onChanged: (value) => _getMunicipios(e: value),

                items: List.generate( listaEstados.length , (index) {
                  var estado = listaEstados[index];
                  return DropdownMenuItem(
                    value: int.parse(estado['idestados']),
                    child: Text( "${estado['Nombre']}" )
                  );
                }),
              ),

              // Municipios
              FormBuilderDropdown<int>(
                name: 'ubi_municipio',
                decoration: const InputDecoration( label: Text("Municipio:") ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "Seleccione su municipio"),
                  FormBuilderValidators.min(1, errorText: "Ingrese un municipio válido"),
                ]),
                onChanged: (value) => _getLocalidades(m: value),

                items: List.generate( listaMunicipios.length , (index) {
                  var municipio = listaMunicipios[index];
                  return DropdownMenuItem(
                    value: int.parse(municipio['idmunicipios']),
                    child: Text("${municipio['Nombre']}")
                  );
                }),
              ),

              // Localidades
              FormBuilderDropdown<int>(
                name: 'ubi_localidades',
                decoration: const InputDecoration( label: Text("Localidad:") ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "Seleccione su localidad"),
                  FormBuilderValidators.min(1, errorText: "Ingrese una localidad válida"),
                ]),

                items: List.generate( listaLocalidades.length , (index) {
                  var localidad = listaLocalidades[index];
                  return DropdownMenuItem(
                    value: int.parse(localidad['idlocalidades']),
                    child: Text("${localidad['Nombre']}"),
                  );
                }),
              ),
            ],
          ),
        ),

        ElevatedButton(
          onPressed: () {
            log("validando...");

            if ( widget.formKey.currentState?.saveAndValidate() ?? false ) {
              log("validado");
              widget.resultado();
            }
            else {
              log("no se pudo");
            }
          },
          child: const Text("Siguiente")
        ),
      ],
    );
  }
}