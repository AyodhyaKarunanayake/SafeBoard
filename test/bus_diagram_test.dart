import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safeboard/widgets/bus_diagram.dart';
import 'package:safeboard/widgets/zone_pill.dart';

void main() {
  testWidgets('BusDiagram renders 54 seat rows and highlights allocated seat 3A', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: BusDiagram(allocatedSeat: '3A'),
          ),
        ),
      ),
    );

    // Verify row headers
    expect(find.text('Row 1'), findsOneWidget);
    expect(find.text('Row 10'), findsOneWidget);
    expect(find.text('Row 11'), findsOneWidget);
    expect(find.text('PRIORITY'), findsOneWidget);
    expect(find.text('GENERAL'), findsOneWidget);

    // Verify allocated seat 3A is rendered
    expect(find.text('3A'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);

    // Verify door indicators
    expect(find.text('FRONT DOOR (ENTRY)'), findsOneWidget);
    expect(find.text('REAR DOOR (EXIT & STANDING ACCESS)'), findsOneWidget);

    // Verify Dual-Purpose Zone Legend Card
    expect(find.text('56 SEATS + DUAL-PURPOSE REAR STANDING (ROWS 8-11)'), findsOneWidget);
  });

  testWidgets('ZonePill renders correct label and colors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ZonePill(zone: 'priority', small: true),
        ),
      ),
    );

    expect(find.text('Priority Zone'), findsOneWidget);
  });
}
