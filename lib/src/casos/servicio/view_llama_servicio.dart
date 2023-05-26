import 'package:beans_driver_flutter/src/comun/dropdown_ubicacion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ViewLlamaServicio extends StatefulWidget {
  const ViewLlamaServicio({super.key});

  @override
  State<ViewLlamaServicio> createState() => _ViewLlamaServicioState();
}

class _ViewLlamaServicioState extends State<ViewLlamaServicio> {

  final GlobalKey<FormBuilderState> llave = GlobalKey<FormBuilderState>();

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

            // Datos del Servicio
            Text("Datos del servicio", style: Theme.of(context).textTheme.headlineSmall, ),

            // Fecha
            FormBuilderDateTimePicker(
              name: 'fecha',
              inputType: InputType.date,
              decoration: const InputDecoration( label: Text("Fecha:") ),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add( const Duration(days: 7) ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Ingrese una fecha válida"),
              ]),
            ),

            // Hora
            FormBuilderDateTimePicker(
              name: 'hora',
              inputType: InputType.time,
              decoration: const InputDecoration( label: Text("Hora:") ),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add( const Duration(hours: 24) ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Ingrese una hora válida"),
              ]),
            ),

            // Tipo de servicio
            FormBuilderRadioGroup<String>(
              name: 'tipoServicio',
              decoration: const InputDecoration( label: Text("Tipo de Servicio:") ),
              orientation: OptionsOrientation.vertical,
              validator: FormBuilderValidators.required(errorText: "Ingrese el tipo de servicio"),
              options: const [
                FormBuilderFieldOption(value: '1', child: Text("Normal", style: TextStyle( fontSize: 20 ), ), ),
                FormBuilderFieldOption(value: '2', child: Text("Recurrente", style: TextStyle( fontSize: 20 ), ), ),
              ],
            ),

            // Ubicación Inicial
            Text("Ubicación Inicial", style: Theme.of(context).textTheme.headlineSmall, ),

            // Calle Inicial
            FormBuilderTextField(
                name: 'calleInicial',
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration( label: Text("Calle Inicial:") ),
                validator: FormBuilderValidators.required(errorText: "Ingrese su calle inicial"),
              ),

            // Ubicacion
            const DropdownUbicacion(
              estadoNombre: 'estadoInicial',
              municipioNombre: 'muniInicial',
              localidadNombre: 'localInicial',
            ),

            // Ubicación Final
            Text("Ubicación Final", style: Theme.of(context).textTheme.headlineSmall, ),

            // Calle Final
            FormBuilderTextField(
                name: 'calleFinal',
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration( label: Text("Calle Final:") ),
                validator: FormBuilderValidators.required(errorText: "Ingrese su calle final"),
              ),

            // Ubicacion
            const DropdownUbicacion(
              estadoNombre: 'estadoFinal',
              municipioNombre: 'muniFinal',
              localidadNombre: 'localFinal',
            ),

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

  void _validaFormulario() {
  }
}