import 'package:beans_driver_flutter/src/modelos/persona.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class TabDatosPersona extends StatefulWidget {

  final Persona per;
  const TabDatosPersona({super.key, required this.per});


  @override
  State<TabDatosPersona> createState() => _TabDatosPersonaState();
}

class _TabDatosPersonaState extends State<TabDatosPersona> {

  late GlobalKey<FormBuilderState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormBuilderState>();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( child: FormBuilder(
      key: formKey,
      onChanged: () => formKey.currentState?.save(),
      initialValue: {
        'nombre': widget.per.nombre ?? '',
        'apellido_1': widget.per.apePrimero ?? '',
        'apellido_2': widget.per.apeSegundo ?? '',
        'genero': widget.per.genero ?? 'I',
        'num_tel': widget.per.numTel ?? '',
      },
      
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FormBuilderTextField(
            name: 'nombre',
            enableSuggestions: true,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              label: const Text("Nombre:"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background
            ),
          ),

          FormBuilderTextField(
            name: 'apellido_1',
            enableSuggestions: true,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              label: const Text("Primer Apellido"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
          ),

          FormBuilderTextField(
            name: 'apellido_2',
            enableSuggestions: true,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              label: const Text("Segundo Apellido"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background
            ),
          ),

          FormBuilderDropdown<String>(
            name: 'genero',
            decoration: InputDecoration(
              label: const Text("Género:"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
            items: const [
              DropdownMenuItem(
                value: 'M',
                child: Text("Masculino"),
              ),
              DropdownMenuItem(
                value: 'F',
                child: Text("Femenino"),
              ),
              DropdownMenuItem(
                value: 'I',
                child: Text("Indistinto"),
              ),
            ],
          ),

          FormBuilderTextField(
            name: 'num_tel',
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: InputDecoration(
              label: const Text("Número telefónico:"),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.numeric(errorText: "Ingrese un número telefónico válido"),
              FormBuilderValidators.match("^[0-9]+\$", errorText: "Ingrese un número telefónico válido"),
              FormBuilderValidators.equalLength(10, errorText: "Su número telefónico debe incluir 10 números"),
            ]),
          ),
        ],
      ), ),
    );
  }
}