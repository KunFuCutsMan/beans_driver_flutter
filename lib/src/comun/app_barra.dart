import 'package:flutter/material.dart';

class AppBarra extends StatefulWidget implements PreferredSizeWidget {
  const AppBarra({super.key});

  @override
  State<AppBarra> createState() => _AppBarraState();
  
  @override
  final Size preferredSize = const Size.fromHeight(60);
}

class _AppBarraState extends State<AppBarra> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Beans Driver"),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}