# Nightfall Creature Registry

A three-screen Flutter app for Activity 11b, extended from our Activity 10 form. Guests enter the registry, complete the guest book, choose a creature companion, and reach a personalized confirmation.

## Team and track

Myles Miller (@ozemoya) and Eziz Bagshiyev (@ezizbagshiyev). Both undergraduate. Shared build only; no graduate extension.

Eziz has been invited to the repository. Each member must explain a screen and submit the artifacts individually. The repository history records the actual author of each commit; no work is attributed to a teammate without evidence.

## Run

```sh
flutter pub get
flutter run
flutter analyze
flutter test
flutter test integration_test/registry_test.dart -d emulator-5554
flutter build apk --release
```

## Screens and navigation

`lib/main.dart` supplies the app theme and WelcomeScreen. Each screen has its own file in `lib/screens/`.

Welcome uses `Navigator.push` to open SignupScreen. The guest can press Back to leave the form. After the form validates, `_submit` waits two seconds and uses `pushReplacement` to replace SignupScreen with SuccessScreen. Only the name and creature type go into the SuccessScreen constructor. Back from success returns to the foyer, not to a completed form. The explicit Back to the Foyer button uses `popUntil`.

## State and lifecycle

SignupScreen owns the name, email, password and date controllers, the password visibility flag, birth date, creature choice, and loading flags. Changing orientation rebuilds the layout without removing that State. Popping the route disposes its four text controllers; a newly opened form starts empty. SuccessScreen owns and disposes its ConfettiController. After the delayed submit or tip request, a mounted check prevents a callback from using a disposed screen.

The birth date ranges from January 1, 1920 through the device's current date. No age restriction is imposed. The original Activity 10 validation is retained: nonblank name and email, an @ in the email, and a password at least six characters long. This is a classroom form demo, not a production account service. Nothing is saved or sent to a server.

## Design

The reference-inspired layout uses warm cream backgrounds, black pill buttons, Anton headings and Barlow Condensed body text. A red guest-book card and an original code-drawn ghost, bat and cat collage carry the creature theme through the flow. The confirmation presents the guest and companion in a roster-style layout. Content scrolls on smaller screens. Password visibility has accessible labels; reduced-motion preferences suppress the animated title and confetti. The Activity 10 password helper remains a local preset feature and never reads form input.

Bundled fonts are from Google Fonts and licensed under the SIL Open Font License; license files are in assets/fonts/.

## Test evidence

The widget suite covers empty fields, malformed email, short password, both visibility states, each of the five creatures, loading and navigation, state retention on resize, leaving mid-load, and five date boundaries. The Android integration test additionally captures screenshots and verifies actual orientation changes and date-input behavior. See `docs/` and the Word document for recorded results.

## Bug notes

The first success-screen test timed out because it waited for all animation to settle while confetti was active. Widget tests now use the platform's reduced-motion flag, while the Android integration test checks the animated app normally.

The first mid-load exit test advanced its fake clock past the delay before completing the reverse route transition. It was corrected to pump the route transition first, then advance the delay. The test now checks the disposed-screen path rather than accidentally allowing the pending navigation to win.

## Submission

Repository: https://github.com/ozemoya/incl11

Submit the release APK, Ghost Hunt Word document and repository URL together. Each member also needs their own live explanation and individual upload. Do not submit a ZIP in place of these artifacts.

A UI issue found during the emulator run was stale validation messages after correcting the fields. The form now starts revalidating edits after the first submit attempt, so old errors clear as the guest corrects them.
