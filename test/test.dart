import 'dart:ffi';

import 'package:assignment_tracker/utils/filter_assignments.dart';
import 'package:assignment_tracker/utils/sort_assignments.dart';
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
  //   late MockSupabaseClient mockSupabaseClient;
  //   late MockNavigatorObserver mockNavigatorObserver;
  //   late TextEditingController courseController;
  //   late TextEditingController nameController;
  //   late TextEditingController typeController;
  //   late TextEditingController dueDateController;
  //   late TextEditingController dueTimeController;
  //   late TextEditingController submissionController;
  //   late TextEditingController resourcesController;
  //
  //   setUp(() {
  //     mockSupabaseClient = MockSupabaseClient();
  //     mockNavigatorObserver = MockNavigatorObserver();
  //     courseController = TextEditingController();
  //     nameController = TextEditingController();
  //     typeController = TextEditingController();
  //     dueDateController = TextEditingController();
  //     dueTimeController = TextEditingController();
  //     submissionController = TextEditingController();
  //     resourcesController = TextEditingController();
  //
  //     //Setting up Supabase client mock
  //     Supabase.instance.client = mockSupabaseClient;
  //     when(mockSupabaseClient.auth.currentUser).thenReturn(MockUser());
  //   });
  //
  //   tearDown(() {
  //     courseController.dispose();
  //     nameController.dispose();
  //     typeController.dispose();
  //     dueDateController.dispose();
  //     dueTimeController.dispose();
  //     submissionController.dispose();
  //     resourcesController.dispose();
  //   });
  //
  //   testWidgets('successful assignment addition', (WidgetTester tester) async {
  //     // Arrange
  //     //when(mockSupabaseClient.from('Assignments').insert(any))
  //         //.thenAnswer((_) async => Future.value());
  //     final initializeData = () {};
  //
  //     courseController.text = 'CPEN';
  //     nameController.text = 'Homework 1';
  //     typeController.text = 'Assignment';
  //     dueDateController.text = '2024-12-31';
  //     dueTimeController.text = '3:00 PM';
  //     submissionController.text = 'Online';
  //     resourcesController.text = 'Book, Notes';
  //
  //     // Act
  //     final result = await addAssignment(
  //       context: tester.element(find.byType(MaterialApp())),
  //       initializeData: initializeData,
  //       courseController: courseController,
  //       nameController: nameController,
  //       typeController: typeController,
  //       dueDateController: dueDateController,
  //       dueTimeController: dueTimeController,
  //       submissionController: submissionController,
  //       resourcesController: resourcesController,
  //     );
  //
  //     // Assert
  //     expect(result, true);
  //     verify(mockSupabaseClient.from('Assignments').insert({
  //       'user_id': any,
  //       'Course': 'Math',
  //       'Name': 'Homework 1',
  //       'Type': 'Assignment',
  //       'Due Date': '2023-10-31',
  //       'Due Time': '3:00 PM PST',
  //       'Submission': 'Online',
  //       'Resources': ['Book', 'Notes'],
  //     })).called(1);
  //   });
     test("filter test", (){
       List<Map<String,dynamic>> currentData;
       bool showOverdue = true;
       String filters = 'course:MATH';

       Map<String,dynamic> task1 = {'Course': 'CPEN221', 'Name': 'Homework1','Type': 'homework',
         'Due Date': '2024-12-24','Due Time': '12:00:00-08', 'submission': 'Online', 'Resources': 'textBook'};
       Map<String,dynamic> task2 = {'Course': 'MATH220', 'Name': 'lab3','Type': 'lab',
         'Due Date': '2024-12-15','Due Time': '12:00:00-08', 'submission': 'Online', 'Resources': 'textBook'};
       Map<String,dynamic> task3 = {'Course': 'MATH220', 'Name': 'Homework2','Type': 'homework',
         'Due Date': '2024-12-31','Due Time': '13:00:00-08', 'submission': 'Online', 'Resources': 'textBook'};

       currentData = [task1,task2,task3];

       List<Map<String,dynamic>> filteredData = filterData(currentData: currentData, showOverdue: showOverdue, filters: filters);
       expect([task2,task3], filteredData);

       filters = 'name:Homework1';
       filteredData = filterData(currentData: currentData, showOverdue: showOverdue, filters: filters);
       expect([task1], filteredData);

       filters = 'type:homework';
       filteredData = filterData(currentData: currentData, showOverdue: showOverdue, filters: filters);
       expect([task1,task3], filteredData);
     });

     test("sort test",(){
       String criteria = "due_date";
       Map<String,dynamic> task1 = {'Course': 'CPEN221', 'Name': 'Homework1','Type': 'homework',
         'Due Date': '2024-12-24','Due Time': '12:30:00+08', 'submission': 'Online', 'Resources': 'textBook'};
       Map<String,dynamic> task2 = {'Course': 'MATH220', 'Name': 'lab3','Type': 'lab',
         'Due Date': '2024-12-15','Due Time': '13:00:00+00', 'submission': 'Online', 'Resources': 'textBook'};
       Map<String,dynamic> task3 = {'Course': 'MATH220', 'Name': 'Homework2','Type': 'homework',
         'Due Date': '2024-12-31','Due Time': '16:00:00+00', 'submission': 'Online', 'Resources': 'textBook'};
       List<Map<String,dynamic>> currentData = [task1];
       currentData.add(task2);
       currentData.add(task3);

       List<Map<String,dynamic>> sortedData = sortData(currentData: currentData, criteria: criteria);

       expect([task2,task1,task3], sortedData);

     });
  });


}