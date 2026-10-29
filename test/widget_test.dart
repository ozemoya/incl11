import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup_app/main.dart';
import 'package:signup_app/screens/signup_screen.dart';
import 'package:signup_app/screens/success_screen.dart';

Finder field(String label) => find.byWidgetPredicate(
  (w) => w is TextField && w.decoration?.labelText == label,
);

Future<void> openForm(WidgetTester tester) async {
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  await tester.pumpWidget(const HauntedMansionApp());
  await tester.ensureVisible(find.text('Enter the Registry'));
  await tester.tap(find.text('Enter the Registry'));
  await tester.pumpAndSettle();
}

Future<void> tapVisible(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> fillForm(WidgetTester tester, String creature) async {
  await tester.enterText(field('Full Name'), 'Myles Miller');
  await tester.enterText(field('Email Address'), 'myles@example.com');
  await tester.enterText(field('Password'), 'secret12');
  await tapVisible(tester, find.byKey(const Key('creature')));
  await tester.tap(find.text(creature).last);
  await tester.pumpAndSettle();
  await tapVisible(tester, field('Birth Date'));
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('all five empty fields block registration', (tester) async {
    await openForm(tester);
    await tapVisible(tester, find.text('Register Creature'));
    for (final error in [
      'Please enter your name',
      'Please enter your email',
      'Please enter a password',
      'Choose your creature type',
      'Pick your birth date',
    ]) {
      expect(find.text(error), findsOneWidget);
    }
    expect(find.byType(SignupScreen), findsOneWidget);
  });

  testWidgets(
    'original email and password rules still apply with visibility toggled',
    (tester) async {
      await openForm(tester);
      await tester.enterText(field('Email Address'), 'invalid');
      await tester.enterText(field('Password'), '12345');
      await tapVisible(tester, find.byTooltip('Show password'));
      expect(tester.widget<TextField>(field('Password')).obscureText, isFalse);
      await tapVisible(tester, find.text('Register Creature'));
      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
      await tapVisible(tester, find.byTooltip('Hide password'));
      expect(tester.widget<TextField>(field('Password')).obscureText, isTrue);
    },
  );

  for (final creature in [
    'Ghost',
    'Bat',
    'Black Cat',
    'Pumpkin Spirit',
    'Witch',
  ]) {
    testWidgets('$creature reaches a personalized confirmation once', (
      tester,
    ) async {
      await openForm(tester);
      await fillForm(tester, creature);
      await tester.ensureVisible(find.text('Register Creature'));
      await tester.tap(find.text('Register Creature'));
      await tester.pump();
      expect(
        tester
            .widget<ElevatedButton>(find.byType(ElevatedButton).first)
            .onPressed,
        isNull,
      );
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      expect(find.text('Welcome, Myles Miller!'), findsOneWidget);
      expect(find.text('Creature registered: $creature.'), findsOneWidget);
      expect(find.byType(SignupScreen), findsNothing);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Enter the Registry'), findsOneWidget);
      expect(find.byType(SignupScreen), findsNothing);
    });
  }

  testWidgets('rotation retains fields but popping the form clears them', (
    tester,
  ) async {
    await openForm(tester);
    await fillForm(tester, 'Black Cat');
    await tapVisible(tester, find.byTooltip('Show password'));
    tester.view.physicalSize = const Size(1000, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
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
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Enter the Registry'));
    await tester.tap(find.text('Enter the Registry'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(field('Full Name')).controller!.text,
      isEmpty,
    );
    expect(
      tester.widget<TextField>(field('Birth Date')).controller!.text,
      isEmpty,
    );
    expect(tester.widget<TextField>(field('Password')).obscureText, isTrue);
  });

  testWidgets('leaving during submission never opens a success route', (
    tester,
  ) async {
    await openForm(tester);
    await fillForm(tester, 'Bat');
    await tester.ensureVisible(find.text('Register Creature'));
    await tester.tap(find.text('Register Creature'));
    await tester.pump();
    await tester.binding.handlePopRoute();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.byType(SuccessScreen), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final date in [
    DateTime(1989, 12, 31),
    DateTime(1990, 1, 1),
    DateTime(2008, 1, 1),
    DateUtils.dateOnly(DateTime.now()),
    DateUtils.dateOnly(DateTime.now()).add(const Duration(days: 1)),
  ]) {
    testWidgets('date boundary ${date.toIso8601String()}', (tester) async {
      await openForm(tester);
      await tapVisible(tester, field('Birth Date'));
      final picker = tester.widget<DatePickerDialog>(
        find.byType(DatePickerDialog),
      );
      final allowed =
          !date.isBefore(picker.firstDate) && !date.isAfter(picker.lastDate);
      expect(allowed, !date.isAfter(DateUtils.dateOnly(DateTime.now())));
      await tester.tap(find.byTooltip('Switch to input'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).last,
        '${date.month}/${date.day}/${date.year}',
      );
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      if (allowed) {
        expect(find.byType(DatePickerDialog), findsNothing);
        expect(
          tester.widget<TextField>(field('Birth Date')).controller!.text,
          '${date.month}/${date.day}/${date.year}',
        );
      } else {
        expect(find.byType(DatePickerDialog), findsOneWidget);
        expect(find.text('Out of range.'), findsOneWidget);
      }
    });
  }
}
