// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';

import 'package:cropfresh_mobile_buyer/main.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CropFreshBuyerApp());

    // Verify that the app name is shown on splash screen
    expect(find.text('CropFresh'), findsOneWidget);
    expect(find.text('B2B Marketplace'), findsOneWidget);
  });
}
