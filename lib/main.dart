import 'package:flutter/material.dart';

import 'controllers/imc_controller.dart';
import 'core/app_theme.dart';
import 'pages/tela_inicial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Mantive um unico controller na raiz para compartilhar os registros entre
  // as telas e descartar esse recurso no ciclo de vida correto.
  // (Doc: State, dispose e ChangeNotifier flutter)
  final ImcController _controller = ImcController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nutri IMC',
      theme: buildAppTheme(),
      home: TelaInicial(controller: _controller),
    );
  }
}
