import 'dart:developer';

import 'package:beans_driver_flutter/src/comun/dialogo_alerta.dart';
import 'package:beans_driver_flutter/src/comun/dropdown_ubicacion.dart';
import 'package:beans_driver_flutter/src/comun/tabbed_contenedor.dart';
import 'package:beans_driver_flutter/src/modelos/cliente.dart';
import 'package:beans_driver_flutter/src/modelos/persona.dart';
import 'package:beans_driver_flutter/src/modelos/servicio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ViewLlamaServicio extends StatefulWidget {

  final int personaID;
  final int usuarioID;
  const ViewLlamaServicio({super.key, required this.personaID, required this.usuarioID});

  @override
  State<ViewLlamaServicio> createState() => _ViewLlamaServicioState();
}

class _ViewLlamaServicioState extends State<ViewLlamaServicio> {

  late Cliente cli = Cliente(usuarioID: widget.usuarioID);
  late Persona per = Persona(personaID: widget.personaID);

  bool _isListo = false;

  final GlobalKey<FormBuilderState> llave = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    
    () async {
      
      await Future.wait([
        cli.obtenClienteEnDB(),
        per.obtenPersonaEnDB(),
      ]);

      log( ">> ${cli.toString()}\n>> ${per.toString()}" );

      setState(() {
        _isListo = true;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: FormBuilder(
        key: llave,
        onChanged: () => llave.currentState?.save(),
        child: Wrap(
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.spaceAround,
          runSpacing: 15,
          children: [

            SizedBox( child: AspectRatio(
              aspectRatio: 10 / 12,
              child: TabbedContenedor(
                tabs: const [
                  'Datos del\nServicio',
                  'Ubicación\nInicial',
                  'Ubicación\nFinal',
                ],
                vistas: [
                  _isListo ? const FormDatosServicio() : const Text(""),
                  _isListo ? FormDatosUbiInicial(per: per) : const Text(""),
                  _isListo ? FormDatosUbiFinal(per: per) : const Text(""),
                ],
              ),
            ), ),

            ElevatedButton(
              onPressed: _validaFormulario,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary
              ),
              child: Text("Editar", style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSecondary
              ), )
            ),
          ],
        ),
      ),
    );
  }

  void _validaFormulario() async {

    if ( llave.currentState?.saveAndValidate() ?? false ) {
      
      // creaServicio( llave.currentState!.value );
      log( ">> ${llave.currentState!.value}" );
    }
    else {
      return DialogoAlerta.avisaInfo(context, "Hubo un error al crear su servicio: Datos incorrectos o nulos");
    }
  }
  
  void creaServicio( Map<String, dynamic> valores ) async {
    // Crea el servicio
    Servicio serv = Servicio(
      servicioID: 0,
      clienteID: cli.clienteID,
      fecha: valores['fecha'],
      hora: valores['hora'],
      detalles: valores['detalles'],
      tipoServicioID: valores['tipoServicio'],
      calleInicial: valores['calleInicial'],
      localidadInicialID: valores['localInicial'],
      municipioInicialID: valores['muniInicial'],
      estadoInicialID: valores['estadoInicial'],
      calleFinal: valores['calleFinal'],
      estadoFinalID: valores['estadoFinal'],
      municipioFinalID: valores['muniFinal'],
      localidadFinalID: valores['localFinal'],
    );

    Map<String, dynamic> res = await serv.insertaEnDB();

    if ( res['stat'] != 200 ) {
      // ignore: use_build_context_synchronously
      return DialogoAlerta.avisaInfo(context, "Hubo un error al crear su servicio: ${res['error']}");
    }
    else {
      // ignore: use_build_context_synchronously
      return DialogoAlerta.avisaInfo(context, "Se creó el servicio de forma exitosa");
    }
  }
}

// Datos del servicio
class FormDatosServicio extends StatefulWidget {
  const FormDatosServicio({super.key});

  @override
  State<FormDatosServicio> createState() => FormDdatosServicioState();
}

class FormDdatosServicioState extends State<FormDatosServicio> with AutomaticKeepAliveClientMixin {
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 15,
      children: [
        // Fecha
        FormBuilderDateTimePicker(
          name: 'fecha',
          inputType: InputType.date,
          decoration: const InputDecoration( label: Text("Fecha:") ),
          firstDate: DateTime.now().subtract( const Duration( seconds: 1 ) ),
          lastDate: DateTime.now().add( const Duration(days: 7) ),
          initialValue: DateTime.now(),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Ingrese una fecha válida"),
          ]),
        ),

        // Hora
        FormBuilderDateTimePicker(
          name: 'hora',
          inputType: InputType.time,
          decoration: const InputDecoration( label: Text("Hora:") ),
          firstDate: DateTime.now().subtract(const Duration( seconds: 1 )),
          lastDate: DateTime.now().add( const Duration(hours: 24) ),
          initialValue: DateTime.now(),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Ingrese una hora válida"),
          ]),
        ),
            
        FormBuilderTextField(
          name: 'detalles',
          decoration: const InputDecoration( label: Text("Detalles") ),
          keyboardType: TextInputType.multiline,
          validator: FormBuilderValidators.maxLength(255, errorText: "Longitud máxima de 255 caracteres"),
          maxLength: 255,
        ),

        // Tipo de servicio
        FormBuilderRadioGroup<int>(
          name: 'tipoServicio',
          decoration: const InputDecoration( label: Text("Tipo de Servicio:") ),
          orientation: OptionsOrientation.vertical,
          validator: FormBuilderValidators.required(errorText: "Ingrese el tipo de servicio"),
          options: const [
            FormBuilderFieldOption(value: 1, child: Text("Normal", style: TextStyle( fontSize: 20 ), ), ),
            FormBuilderFieldOption(value: 2, child: Text("Recurrente", style: TextStyle( fontSize: 20 ), ), ),
          ],
        ),
      ],
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

// Datos de la ubicación inicial
class FormDatosUbiInicial extends StatefulWidget {

  final Persona per;
  const FormDatosUbiInicial({super.key, required this.per});

  @override
  State<FormDatosUbiInicial> createState() => _FormDatosUbiInicialState();
}

class _FormDatosUbiInicialState extends State<FormDatosUbiInicial> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 15,
      children: [
        // Calle Inicial
        FormBuilderTextField(
          name: 'calleInicial',
          keyboardType: TextInputType.streetAddress,
          decoration: const InputDecoration( label: Text("Calle Inicial:") ),
          validator: FormBuilderValidators.required(errorText: "Ingrese su calle inicial"),
        ),
        
        // Ubicacion
        DropdownUbicacion(
          estadoNombre: 'estadoInicial',
          municipioNombre: 'muniInicial',
          localidadNombre: 'localInicial',
          estadoID: widget.per.estadoID,
          municipioID: widget.per.municipioID,
          localidadID: widget.per.localidadID,
        ),

      ],
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

// Datos de la ubicación final
class FormDatosUbiFinal extends StatefulWidget {
  
  final Persona per;
  const FormDatosUbiFinal({super.key, required this.per});

  @override
  State<FormDatosUbiFinal> createState() => _FormDatosUbiFinalState();
}

class _FormDatosUbiFinalState extends State<FormDatosUbiFinal> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 15,
      children: [
        // Calle Final
        FormBuilderTextField(
          name: 'calleFinal',
          keyboardType: TextInputType.streetAddress,
          decoration: const InputDecoration( label: Text("Calle Final:") ),
          validator: FormBuilderValidators.required(errorText: "Ingrese su calle final"),
        ),

            // Ubicacion
        DropdownUbicacion(
          estadoNombre: 'estadoFinal',
          municipioNombre: 'muniFinal',
          localidadNombre: 'localFinal',
          estadoID: widget.per.estadoID,
          municipioID: widget.per.municipioID,
          localidadID: widget.per.localidadID,
        ),

      ],
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}