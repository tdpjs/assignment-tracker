import 'package:assignment_tracker/utils/table_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart'; // Adjust the import
import 'package:supabase/supabase.dart';

import 'test.mocks.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('addAssignment', () {
    late MockSupabaseClient mockSupabaseClient;
    late MockNavigatorObserver mockNavigatorObserver;
    late TextEditingController courseController;
    late TextEditingController nameController;
    late TextEditingController typeController;
    late TextEditingController dueDateController;
    late TextEditingController dueTimeController;
    late TextEditingController submissionController;
    late TextEditingController resourcesController;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      mockNavigatorObserver = MockNavigatorObserver();
      courseController = TextEditingController();
      nameController = TextEditingController();
      typeController = TextEditingController();
      dueDateController = TextEditingController();
      dueTimeController = TextEditingController();
      submissionController = TextEditingController();
      resourcesController = TextEditingController();

      // Setting up Supabase client mock
      Supabase.instance.client = mockSupabaseClient;
      when(mockSupabaseClient.auth.currentUser).thenReturn(MockUser());
    });

    tearDown(() {
      courseController.dispose();
      nameController.dispose();
      typeController.dispose();
      dueDateController.dispose();
      dueTimeController.dispose();
      submissionController.dispose();
      resourcesController.dispose();
    });

    testWidgets('successful assignment addition', (WidgetTester tester) async {
      // Arrange
      when(mockSupabaseClient.from('Assignments').insert(any))
          .thenAnswer((_) async => Future.value());
      final initializeData = () {};

      courseController.text = 'Math';
      nameController.text = 'Homework 1';
      typeController.text = 'Assignment';
      dueDateController.text = '2023-10-31';
      dueTimeController.text = '3:00 PM';
      submissionController.text = 'Online';
      resourcesController.text = 'Book, Notes';

      // Act
      final result = await addAssignment(
        context: tester.element(find.byType(MaterialApp())),
        initializeData: initializeData,
        courseController: courseController,
        nameController: nameController,
        typeController: typeController,
        dueDateController: dueDateController,
        dueTimeController: dueTimeController,
        submissionController: submissionController,
        resourcesController: resourcesController,
      );

      // Assert
      expect(result, true);
      verify(mockSupabaseClient.from('Assignments').insert({
        'user_id': any,
        'Course': 'Math',
        'Name': 'Homework 1',
        'Type': 'Assignment',
        'Due Date': '2023-10-31',
        'Due Time': '3:00 PM PST',
        'Submission': 'Online',
        'Resources': ['Book', 'Notes'],
      })).called(1);
    });

    testWidgets('returns false when user ID is null', (WidgetTester tester) async {
      // Arrange
      when(mockSupabaseClient.auth.currentUser).thenReturn(null);
      final initializeData = () {};

      // Act
      final result = await addAssignment(
        context: tester.element(find.byType(MaterialApp())),
        initializeData: initializeData,
        courseController: courseController,
        nameController: nameController,
        typeController: typeController,
        dueDateController: dueDateController,
        dueTimeController: dueTimeController,
        submissionController: submissionController,
        resourcesController: resourcesController,
      );

      // Assert
      expect(result, false);
    });

    testWidgets('returns false when there is an exception', (WidgetTester tester) async {
      // Arrange
      when(mockSupabaseClient.from('Assignments').insert(any)).thenThrow(Exception('Database error'));
      final initializeData = () {};

      // Act
      final result = await addAssignment(
        context: tester.element(find.byType(MaterialApp())),
        initializeData: initializeData,
        courseController: courseController,
        nameController: nameController,
        typeController: typeController,
        dueDateController: dueDateController,
        dueTimeController: dueTimeController,
        submissionController: submissionController,
        resourcesController: resourcesController,
      );

      // Assert
      expect(result, false);
    });
  });
}