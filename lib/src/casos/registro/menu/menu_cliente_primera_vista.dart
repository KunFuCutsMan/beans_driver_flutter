import 'package:flutter/material.dart';

class PrimeraVista extends StatelessWidget {
  const PrimeraVista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Beans Driver")),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast
        ),
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 50, right: 50),
          )
        ],
      ),
    );
  }
}
