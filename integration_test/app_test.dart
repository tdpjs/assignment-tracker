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

    testWidgets("add test",(tester) async {
      app.main();

      await tester.pumpAndSettle();



      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;


      final addAssignment = find.byKey(Key('add'));
      final courseField = find.byKey(Key('courseField'));
      final nameField = find.byKey(Key('nameField'));
      final typeField = find.byKey(Key('typeField'));
      final dueDateField = find.byKey(Key('dueDateField'));
      final dueTimeField = find.byKey(Key('dueTimeField'));
      final submissionField = find.byKey(Key('submissionField'));
      final resourcesField = find.byKey(Key('resourcesField'));
      final addButton = find.byKey(Key('addButton'));

      await tester.tap(addAssignment);

      await tester.pumpAndSettle();

      await tester.enterText(courseField, "MATH221");
      await tester.enterText(nameField, "lab11");
      await tester.enterText(typeField, "lab");
      await tester.enterText(dueDateField, "2024-12-31");
      await tester.enterText(dueTimeField, "11:59 UTC");
      await tester.enterText(submissionField,'github');
      await tester.enterText(resourcesField, "123");

      await tester.pumpAndSettle();

      await tester.tap(addButton);

      await tester.pumpAndSettle();

      expect(find.text("CPEN221"), findsOneWidget);
      expect(find.text("lab11"), findsOneWidget);
      expect(find.text("lab"), findsOneWidget);
      expect(find.text("2024-12-24"), findsOneWidget);
      expect(find.text("11:59 UTC"), findsOneWidget);
      expect(find.text("github"), findsOneWidget);
      expect(find.text("123"), findsOneWidget);

      await tester.tap(addAssignment);

      await tester.pumpAndSettle();

      await tester.enterText(courseField, "CPEN211");
      await tester.enterText(nameField, "lab1");
      await tester.enterText(typeField, "lab");
      await tester.enterText(dueDateField, "2024-12-31");
      await tester.enterText(dueTimeField, "11:59 PST");
      await tester.enterText(submissionField,'github');
      await tester.enterText(resourcesField, "123");

      await tester.pumpAndSettle();

      await tester.tap(addButton);

      await tester.pumpAndSettle();

      final firstRow = find.byKey(Key('dataRow')).first;
      final deleteIcon = find.byIcon(Icons.delete).first;
      final deleteButton = find.byKey(Key('deletButton'));

      expect(deleteIcon, findsNothing);
      await tester.pumpAndSettle();
      await tester.tap(deleteIcon);

      await tester.pumpAndSettle();

      await tester.tap(deleteButton);

    });

     testWidgets("test delete", (tester) async{
        app.main();
       final addAssignment = find.byKey(Key('add'));
       final courseField = find.byKey(Key('courseField'));
       final nameField = find.byKey(Key('nameField'));
       final typeField = find.byKey(Key('typeField'));
       final dueDateField = find.byKey(Key('dueDateField'));
       final dueTimeField = find.byKey(Key('dueTimeField'));
       final submissionField = find.byKey(Key('submissionField'));
       final resourcesField = find.byKey(Key('resourcesField'));
       final addButton = find.byKey(Key('addButton'));
       await tester.pumpAndSettle();

       await tester.tap(addAssignment);

       await tester.pumpAndSettle();

       await tester.enterText(courseField, "CPEN211");
       await tester.enterText(nameField, "lab1");
       await tester.enterText(typeField, "lab");
       await tester.enterText(dueDateField, "2024-12-31");
       await tester.enterText(dueTimeField, "11:59 PST");
       await tester.enterText(submissionField,'github');
       await tester.enterText(resourcesField, "123");

       await tester.pumpAndSettle();

       await tester.tap(addButton);

     });

  });

}

