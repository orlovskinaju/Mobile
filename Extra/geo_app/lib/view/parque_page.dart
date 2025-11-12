import 'package:flutter/material.dart';
import 'package:geo_app/controller/parque_controller.dart';

final appKey = GlobalKey();

class ParquePage extends StatelessWidget {
  const ParquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('Meu local'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider<ParqueController>(
        create: (context) => ParqueController(),
        child: Builder(builder: context){
          final local = context.watch<ParqueController>();
          Sstring mensagem = local.erro == ''? 'Latitude: ${local.lat}\nLongitude: ${local.long}' : local.erro;
          return Center(chilf Text(mensagem));
        },
      ),
    );
  }
}