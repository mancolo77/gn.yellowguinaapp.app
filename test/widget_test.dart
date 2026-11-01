import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_yellowguinaapp/screens/main_navigation_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MainNavigationScreen displays 3 tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainNavigationScreen(),
      ),
    );
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Calendrier'), findsOneWidget);
    expect(find.text('Favoris'), findsOneWidget);
    expect(find.text('Mon profil'), findsOneWidget);
  });
}
