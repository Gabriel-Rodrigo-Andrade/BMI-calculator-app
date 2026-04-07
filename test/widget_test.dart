import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:imc_calc/main.dart';

void main() {
  testWidgets('deve abrir a tela inicial e navegar para a lista',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('ACESSAR'), findsOneWidget);

    await tester.ensureVisible(find.text('ACESSAR'));
    await tester.tap(find.text('ACESSAR'));
    await tester.pumpAndSettle();

    expect(find.text('LISTA DE PACIENTES'), findsOneWidget);
    expect(find.text('Ana Silva'), findsOneWidget);
    expect(find.text('Carlos Mendes'), findsOneWidget);
    expect(find.byIcon(Icons.question_mark), findsOneWidget);

    await tester.tap(find.byIcon(Icons.question_mark));
    await tester.pumpAndSettle();

    expect(find.text('Classificacao do IMC'), findsOneWidget);
    expect(find.text('De 18,5 ate 24,9: Peso normal'), findsOneWidget);
  });
}
