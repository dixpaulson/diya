import 'package:flutter_test/flutter_test.dart';

import 'package:diya/main.dart';

void main() {
  testWidgets('Diya home screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const DiyaApp());

    // The app name and the today's-prayer section should be on screen.
    expect(find.text('Diya'), findsWidgets);
    expect(find.text('Today’s prayer'), findsOneWidget);
  });
}
