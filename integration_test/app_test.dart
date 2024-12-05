import 'package:flutter/material.dart';
//import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
//import 'package:test/test.dart';
import 'package:assignment_tracker/main.dart' as app;

/**automation test**/
void main() {
  group('testing',(){
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    //late FlutterDriver driver;

    testWidgets("add + delete",(tester) async {
      app.main();

      await tester.pumpAndSettle();

      final addAssignment = find.byKey(Key('add'));
      await tester.pumpAndSettle();
      expect(addAssignment, findsOneWidget); // Ensure the widget exists
      print('addAssignment widget: ${addAssignment.evaluate()}');

      await tester.pumpAndSettle();

      await tester.tap(addAssignment);

      await tester.pumpAndSettle();

      // Repeat for all other finders
      final courseField = find.byKey(Key('courseField'));
      expect(courseField, findsOneWidget); // Ensure the widget exists
      print('courseField widget: ${courseField.evaluate()}');

      await tester.pumpAndSettle();

      final nameField = find.byKey(Key('nameField'));
      expect(nameField, findsOneWidget);
      print('nameField widget: ${nameField.evaluate()}');

      await tester.pumpAndSettle();

      final typeField = find.byKey(Key('typeField'));
      expect(typeField, findsOneWidget);
      print('typeField widget: ${typeField.evaluate()}');

      await tester.pumpAndSettle();

      final dueDateField = find.byKey(Key('dueDateField'));
      expect(dueDateField, findsOneWidget);
      print('dueDateField widget: ${dueDateField.evaluate()}');

      await tester.pumpAndSettle();

      final dueTimeField = find.byKey(Key('dueTimeField'));
      expect(dueTimeField, findsOneWidget);
      print('dueTimeField widget: ${dueTimeField.evaluate()}');

      await tester.pumpAndSettle();

      final submissionField = find.byKey(Key('submissionField'));
      expect(submissionField, findsOneWidget);
      print('submissionField widget: ${submissionField.evaluate()}');

      await tester.pumpAndSettle();

      final resourcesField = find.byKey(Key('resourcesField'));
      expect(resourcesField, findsOneWidget);
      print('resourcesField widget: ${resourcesField.evaluate()}');

      await tester.pumpAndSettle();

      final addButton = find.byKey(Key('addButton'));
      expect(addButton, findsOneWidget);
      print('addButton widget: ${addButton.evaluate()}');

      await tester.pumpAndSettle();

      await tester.enterText(courseField, "MATH221");
      await tester.pumpAndSettle();
      expect(find.text("MATH221"), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.enterText(nameField, "lab11");
      await tester.pumpAndSettle();
      expect(find.text("lab11"), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.enterText(typeField, "lab");
      await tester.pumpAndSettle();
      expect(find.text("lab"), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.enterText(dueDateField, "2024-12-31");
      await tester.pumpAndSettle();
      expect(find.text("2024-12-31"), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.enterText(dueTimeField, "11:59 UTC");
      await tester.pumpAndSettle();
      expect(find.text("11:59 UTC"), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.enterText(submissionField,'github');
      await tester.pumpAndSettle();
      expect(find.text("github"), findsAtLeast(1));
      await tester.pumpAndSettle();
      await tester.enterText(resourcesField, "123");
      await tester.pumpAndSettle();
      expect(find.text("123"), findsAtLeast(1));
      await tester.pumpAndSettle();

      await tester.tap(addButton);

      await tester.pumpAndSettle();

      final editIcon = find.byIcon(Icons.edit);

      await tester.pumpAndSettle();

      expect(editIcon, findsAtLeast(1));

      await tester.pumpAndSettle();

      await tester.tap(editIcon);

      await tester.pumpAndSettle();

      final courseField2 = find.byKey(Key('courseField'));
      expect(courseField2, findsOneWidget); // Ensure the widget exists
      print('courseField widget: ${courseField.evaluate()}');

      await tester.pumpAndSettle();

      final nameField2 = find.byKey(Key('nameField'));
      expect(nameField2, findsOneWidget);
      print('nameField widget: ${nameField.evaluate()}');

      await tester.pumpAndSettle();

      final typeField2 = find.byKey(Key('typeField'));
      expect(typeField2, findsOneWidget);
      print('typeField widget: ${typeField.evaluate()}');

      await tester.pumpAndSettle();

      final dueDateField2 = find.byKey(Key('dueDateField'));
      expect(dueDateField2, findsOneWidget);
      print('dueDateField widget: ${dueDateField.evaluate()}');

      await tester.pumpAndSettle();

      final dueTimeField2 = find.byKey(Key('dueTimeField'));
      expect(dueTimeField2, findsOneWidget);
      print('dueTimeField widget: ${dueTimeField.evaluate()}');

      await tester.pumpAndSettle();

      final submissionField2 = find.byKey(Key('submissionField'));
      expect(submissionField2, findsOneWidget);
      print('submissionField widget: ${submissionField.evaluate()}');

      await tester.pumpAndSettle();

      final resourcesField2 = find.byKey(Key('resourcesField'));
      expect(resourcesField2, findsOneWidget);
      print('resourcesField widget: ${resourcesField.evaluate()}');

      await tester.pumpAndSettle();

      final editButton = find.byKey(Key('addButton'));
      expect(editButton, findsOneWidget);
      print('editButton widget: ${addButton.evaluate()}');

      await tester.pumpAndSettle();

      expect(find.text("MATH221"), findsOneWidget);
      await tester.pumpAndSettle();

      expect(find.text("lab11"), findsOneWidget);
      await tester.pumpAndSettle();

      expect(find.text("lab"), findsOneWidget);
      await tester.pumpAndSettle();

      expect(find.text("2024-12-31"), findsOneWidget);
      await tester.pumpAndSettle();

      expect(find.text("11:59 UTC"), findsOneWidget);
      await tester.pumpAndSettle();

      expect(find.text("github"), findsOneWidget);
      await tester.pumpAndSettle();

      expect(find.text("123"), findsOneWidget);
      await tester.pumpAndSettle();

      await tester.enterText(courseField2, "CPEN221");

      await tester.pumpAndSettle();

      expect(find.text("MATH221"), findsNothing);
      await tester.pumpAndSettle();

      expect(find.text("CPEN221"), findsOneWidget);
      await tester.pumpAndSettle();

      await tester.tap(editButton);

      await tester.pumpAndSettle();

      /// DELETE

      final deleteIcon = find.byIcon(Icons.delete).first;

      await tester.pumpAndSettle();

      expect(deleteIcon, findsNothing);
      await tester.pumpAndSettle();
      expect(deleteIcon, findsOneWidget);

      await tester.pumpAndSettle();

      await tester.tap(deleteIcon);

      await tester.pumpAndSettle();

      final deleteButton = find.byKey(Key('deleteButton')).first;

      await tester.pumpAndSettle();

      await tester.tap(deleteButton);

      await tester.tap(deleteIcon);

      await tester.pumpAndSettle();

      // expect(deleteIcon, findsNothing);
      //
      // await tester.pumpAndSettle();
    });

    testWidgets("add + delete",(tester) async {
      app.main();

    });
  });


}

