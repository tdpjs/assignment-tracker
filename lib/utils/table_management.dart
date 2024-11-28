import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Adds an assignment to the database.
/// [fetchUserData] is the callback to fetch user data after the operation.
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

      await Supabase.instance.client.from('Assignments').insert({
        'user_id': userId,
        'Course': courseController.text,
        'Name': nameController.text,
        'Type': typeController.text,
        'Due Date': dueDateController.text,
        'Due Time': dueTimeController.text,
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
/// [fetchUserData] is the callback to fetch user data after the operation.
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

      await Supabase.instance.client
          .from('Assignments')
          .update({
        'Course': courseController.text,
        'Name': nameController.text,
        'Type': typeController.text,
        'Due Date': dueDateController.text,
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
/// [fetchUserData] is the callback to fetch user data after the operation.
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
