import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:signup_app/main.dart';
import 'package:signup_app/screens/signup_screen.dart';

Finder field(String label) => find.byWidgetPredicate(
  (w) => w is TextField && w.decoration?.labelText == label,
);

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('emulator navigation date boundaries and rotation', (
    tester,
  ) async {
    await tester.pumpWidget(const HauntedMansionApp());
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pump();
    Future<void> capture(String name) async {
      await binding.takeScreenshot(name);
      debugPrint('EVIDENCE $name');
    }

    Future<void> tap(Finder f) async {
      await tester.ensureVisible(f);
      await tester.pumpAndSettle();
      await tester.tap(f);
      await tester.pumpAndSettle();
    }

    await capture('welcome');
    await tap(find.text('Enter the Registry'));
    await tap(find.text('Register Creature'));
    expect(find.text('Choose your creature type'), findsOneWidget);
    await capture('validation');
    await tester.enterText(field('Full Name'), 'Myles Miller');
    await tester.enterText(field('Email Address'), 'myles@example.com');
    await tester.enterText(field('Password'), 'testonly12');
    await tap(find.byKey(const Key('creature')));
    await tap(find.text('Black Cat').last);
    await tap(field('Birth Date'));
    await tap(find.text('OK'));
    await tap(find.byTooltip('Show password'));
    await capture('portrait-state');
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    await tester.pumpAndSettle();
    await Future<void>.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(field('Full Name')).controller!.text,
      'Myles Miller',
    );
    expect(
      tester.widget<TextField>(field('Birth Date')).controller!.text,
      '1/1/2008',
    );
    expect(tester.widget<TextField>(field('Password')).obscureText, isFalse);
    expect(find.text('Black Cat'), findsOneWidget);
    await capture('landscape-state');
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await Future<void>.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    final today = DateUtils.dateOnly(DateTime.now());
    final dates = [
      DateTime(1989, 12, 31),
      DateTime(1990, 1, 1),
      DateTime(2008, 1, 1),
      today,
      today.add(const Duration(days: 1)),
    ];
    for (var i = 0; i < dates.length; i++) {
      final d = dates[i];
      await tap(field('Birth Date'));
      await tap(find.byTooltip('Switch to input'));
      await tester.enterText(
        find.byType(TextField).last,
        '${d.month}/${d.day}/${d.year}',
      );
      await tap(find.text('OK'));
      if (i == 4) {
        expect(find.text('Out of range.'), findsOneWidget);
        await capture('date-future-rejected');
        await tap(find.text('Cancel'));
      } else {
        expect(find.byType(DatePickerDialog), findsNothing);
        expect(
          tester.widget<TextField>(field('Birth Date')).controller!.text,
          '${d.month}/${d.day}/${d.year}',
        );
        await capture('date-$i-accepted');
      }
    }
    await tap(find.byTooltip('Hide password'));
    await tap(find.text('Register Creature'));
    await Future<void>.delayed(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, Myles Miller!'), findsOneWidget);
    expect(find.text('Creature registered: Black Cat.'), findsOneWidget);
    expect(find.byType(SignupScreen), findsNothing);
    await capture('success');
    await tap(find.text('Back to the Foyer'));
    await tap(find.text('Enter the Registry'));
    expect(
      tester.widget<TextField>(field('Full Name')).controller!.text,
      isEmpty,
    );
    expect(
      tester.widget<TextField>(field('Birth Date')).controller!.text,
      isEmpty,
    );
    await capture('fresh-form');
  });
}
