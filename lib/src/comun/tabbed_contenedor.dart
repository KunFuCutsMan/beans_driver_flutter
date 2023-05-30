import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';

/// Wrapper de [ContainedTabVarView] con colores primarios de la aplicación
/// 
/// La longitud de los arreglos de [tabs] y [vistas] debe de ser la misma.
class TabbedContenedor extends StatelessWidget {

  final List<String> tabs;
  final List<Widget> vistas;

  const TabbedContenedor({super.key, required this.tabs, required this.vistas});

  @override
  Widget build(BuildContext context) {
    return ContainedTabBarView(
      tabBarProperties: TabBarProperties(
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.vertical( top: Radius.circular(10) )
        ),
        
        labelColor: Theme.of(context).colorScheme.onPrimary,
        labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        ),

        unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
        unselectedLabelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      
      tabs: tabs
        .map( (texto) => Text(texto, textAlign: TextAlign.center) )
        .toList(),

      views: vistas
        .map( (widget) => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.vertical( bottom: Radius.circular(10) )
          ),
          child: widget,
        ) )
        .toList(),
    );
  }
}