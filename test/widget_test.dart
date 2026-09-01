import 'package:flutter_test/flutter_test.dart';
import 'package:safeboard/app.dart';

void main() {
  testWidgets('SafeBoardApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SafeBoardApp());
    expect(find.text('SafeBoard'), findsWidgets);
  });
}
