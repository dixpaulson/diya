import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:diya/main.dart';
import 'package:diya/profile.dart';

void main() {
  testWidgets('Diya home screen loads', (WidgetTester tester) async {
    // A phone-sized screen, like the ones the app is designed for.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    // main() loads the saved settings before starting the app, so do the same
    // here, as a returning user who has already finished the welcome flow.
    SharedPreferences.setMockInitialValues({'onboarded': true});
    await Profile.init();

    await tester.pumpWidget(const DiyaApp());

    // The app name is at the top; the today's-prayer section is further down.
    expect(find.text('Diya'), findsWidgets);
    await tester.scrollUntilVisible(find.text('Today’s prayer'), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Today’s prayer'), findsOneWidget);
  });
}
