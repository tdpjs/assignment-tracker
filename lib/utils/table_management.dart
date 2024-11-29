import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Adds an assignment to the database.
/// @param [context] the current BuildContext of the app
/// @param [initializeData] is the callback to fetch user data after the operation.
/// @param [courseController] the text controller for the course field of the assignment
/// @param [nameController] the text controller for the name field of the assignment
/// @param [typeController] the text controller for the type field of the assignment
/// @param [dueDateController] the text controller for the due date field of the assignment
/// @param [dueTimeController] the text controller for the due time field of the assignment
/// @param [submissionController] the text controller for the submission field of the assignment
/// @param [resourcesController] the text controller for the resources field of the assignment
/// @returns true if the addition is successful and false otherwise
Future<bool> addAssignment({
  required BuildContext context,
  required VoidCallback initializeData,
  required TextEditingController courseController,
  required TextEditingController nameController,
  required TextEditingController typeController,
  required TextEditingController dueDateController,
  required TextEditingController dueTimeController,
  required TextEditingController submissionController,
  required TextEditingController resourcesController,
}) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId != null) {
    try {
      final List<String> resources = resourcesController.text
          .split(',')
          .map((s) => s.trim())
          .toList();

      String dueTime = dueTimeController.text;
      final timeParts = dueTime.split(RegExp(r'\s+'));
      if (timeParts.length == 1 || !RegExp(r'^[A-Z]{2,4}$').hasMatch(timeParts.last)) {
        dueTime = '$dueTime PST';
      }

      await Supabase.instance.client.from('Assignments').insert({
        'user_id': userId,
        'Course': courseController.text,
        'Name': nameController.text,
        'Type': typeController.text,
        'Due Date': dueDateController.text,
        'Due Time': dueTime,
        'Submission': submissionController.text,
        'Resources': resources,
      });

      initializeData();
      Navigator.of(context).pop();
    } catch (error) {
      print('Error adding assignment: $error');
      return false;
    }
    return true;
  }
  return false;
}


/// Edits an assignment in the database.
/// @param [context] the current BuildContext of the app
/// @param [initializeData] is the callback to fetch user data after the operation.
/// @param [data] the current assignment entry
/// @param [courseController] the text controller for the course field of the assignment
/// @param [nameController] the text controller for the name field of the assignment
/// @param [typeController] the text controller for the type field of the assignment
/// @param [dueDateController] the text controller for the due date field of the assignment
/// @param [dueTimeController] the text controller for the due time field of the assignment
/// @param [submissionController] the text controller for the submission field of the assignment
/// @param [resourcesController] the text controller for the resources field of the assignment
/// @returns true if the operation is successful and false otherwise
Future<bool> editAssignment({
  required BuildContext context,
  required VoidCallback initializeData,
  required Map<String, dynamic> data,
  required TextEditingController courseController,
  required TextEditingController nameController,
  required TextEditingController typeController,
  required TextEditingController dueDateController,
  required TextEditingController dueTimeController,
  required TextEditingController submissionController,
  required TextEditingController resourcesController,
}) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId != null) {
    try {
      final List<String> resources = resourcesController.text
          .split(',')
          .map((s) => s.trim())
          .toList();

      String dueTime = dueTimeController.text;
      final timeParts = dueTime.split(RegExp(r'\s+'));
      if (timeParts.length == 1 || !RegExp(r'^[A-Z]{2,4}$').hasMatch(timeParts.last)) {
        dueTime = '$dueTime PST';
      }

      await Supabase.instance.client
          .from('Assignments')
          .update({
        'Course': courseController.text,
        'Name': nameController.text,
        'Type': typeController.text,
        'Due Date': dueTime,
        'Due Time': dueTimeController.text,
        'Submission': submissionController.text,
        'Resources': resources,
      }).eq('id', data['id']);

      initializeData();
      Navigator.of(context).pop();
      return true;
    } catch (error) {
      print('Error updating assignment: $error');
      return false;
    }
  }
  return true;
}

/// Deletes an assignment from the database.
/// @param [context] the current BuildContext of the app
/// @param [initializeData] is the callback to fetch user data after the operation.
/// @param [data] the current assignment entry
/// /// @returns true if the operation is successful and false otherwise
Future<bool> deleteAssignment({
  required BuildContext context,
  required VoidCallback initializeData,
  required Map<String, dynamic> data,
}) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId != null) {
    try {
      await Supabase.instance.client
          .from('Assignments')
          .delete()
          .eq('id', data['id']);

      initializeData();
      Navigator.of(context).pop();
      return true;
    } catch (error) {
      print('Error deleting assignment: $error');
      return false;
    }
  }
  return true;
}
