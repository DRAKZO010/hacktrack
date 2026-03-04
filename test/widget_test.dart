import 'package:flutter_test/flutter_test.dart';

import 'package:hacktrack/main.dart';

void main() {
  testWidgets('App launches and shows splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const HackTrackApp());

    // Verify the splash screen renders with the app name
    expect(find.text('HackTrack'), findsOneWidget);
    expect(find.text('Never Miss a Hackathon'), findsOneWidget);

    // Advance past the 3-second splash timer to avoid pending timer assertion
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}
