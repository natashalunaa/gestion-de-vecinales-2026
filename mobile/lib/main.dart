import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // ProviderScope es el contenedor raíz de Riverpod para toda la aplicación
    const ProviderScope(
      child: DesmalezadoApp(),
    ),
  );
}
