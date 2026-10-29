import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/app.dart';

void main() {
  testWidgets('App smoke test loads login screen with Riverpod', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: DesmalezadoApp(),
      ),
    );

    // Verifica que la pantalla de login institucional cargue correctamente
    expect(find.text('Gestión de Desmalezado'), findsOneWidget);
    expect(find.text('Ingresar al Sistema'), findsOneWidget);
  });
}
