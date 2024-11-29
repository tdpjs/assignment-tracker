import 'package:assignment_tracker/utils/table_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//import 'test.mocks.dart';

class MockBuildContext extends Mock implements BuildContext {}
// Mock User class

class MockPostgrestResponse extends Mock implements PostgrestResponse{}

class MockSupabaseClient extends Mock implements SupabaseClient{
}

class MockUser extends Mock implements User{}



// Mock classes
@GenerateMocks([SupabaseClient, User])
void main() {
  group('addAssignment', () {
    late MockSupabaseClient mockSupabaseClient;
    late MockBuildContext mockContext;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      mockContext = MockBuildContext();
    });

    test('returns true on successful insertion', () async {
      // Mock Supabase auth and insert behavior
      final mockAuthResponse = MockUser();
      when(mockSupabaseClient.auth.currentUser).thenReturn(mockAuthResponse);
      when(mockAuthResponse.id).thenReturn('123dfg');

      final mockInsertResponse = MockPostgrestResponse();
      //when(mockInsertResponse.error).thenReturn(null);

     // when(mockSupabaseClient.from('Assignments').insert(any)).thenAnswer(
     //       (_) async => mockInsertResponse,
    //  );

      // Mock controllers
      final courseController = TextEditingController(text: 'CPEN221');
      final nameController = TextEditingController(text: 'Assignment 1');
      final typeController = TextEditingController(text: 'Homework');
      final dueDateController = TextEditingController(text: '2024-12-01');
      final dueTimeController = TextEditingController(text: '23:59 UTC');
      final submissionController = TextEditingController(text: 'Online');
      final resourcesController = TextEditingController(text: 'book.pdf, notes.docx');

      // Mock initializeData callback
      final initializeData = () {};

      final result = await addAssignment(
        context: mockContext,
        initializeData: initializeData,
        courseController: courseController,
        nameController: nameController,
        typeController: typeController,
        dueDateController: dueDateController,
        dueTimeController: dueTimeController,
        submissionController: submissionController,
        resourcesController: resourcesController,
      );

      expect(result, true);

      // Verify interactions
      //verify(mockSupabaseClient.from('Assignments').insert()).called(1);
    });
  });
}
