import 'package:assignment_tracker/utils/time_parsing.dart';
import 'package:flutter/material.dart';
import '../build_cells/link_cell.dart';
import '../build_cells/resources_cell.dart';
import '../build_cells/text_cell.dart';
import '../build_cells/time_cell.dart';
import '../dialogs/delete_dialog.dart';
import '../dialogs/edit_dialog.dart';

/// Widget that represent the Data Table to be displayed
class AssignmentsTable extends StatelessWidget {
  final BuildContext context;
  final TextEditingController courseController;
  final TextEditingController nameController;
  final TextEditingController typeController;
  final TextEditingController dueDateController;
  final TextEditingController dueTimeController;
  final TextEditingController submissionController;
  final TextEditingController resourcesController;
  final Future<bool> Function() initializeData;
  final List<Map<String, dynamic>> currentData;

  const AssignmentsTable({
    super.key,
    required this.context,
    required this.courseController,
    required this.nameController,
    required this.typeController,
    required this.dueDateController,
    required this.dueTimeController,
    required this.submissionController,
    required this.resourcesController,
    required this.initializeData,
    required this.currentData,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: SelectableText('Course')),
        DataColumn(label: SelectableText('Name')),
        DataColumn(label: SelectableText('Type')),
        DataColumn(label: SelectableText('Due Date')),
        DataColumn(label: SelectableText('Due Time')),
        DataColumn(label: SelectableText('Submission')),
        DataColumn(label: SelectableText('Resources')),
        DataColumn(label: SelectableText('Actions')),
      ],
      rows: currentData.map((data) {
        key: const Key('dataRow');
        return DataRow(

          cells: [
            TextCell(name: 'Course', content: data['Course'], context: context),
            TextCell(name: 'Name', content: data['Name'], context: context),
            TextCell(name: 'Type', content: data['Type'], context: context),
            TextCell(name: 'Due Date', content: data['Due Date'], context: context),
            TimeCell(time: convertToTimeZoneFormat(data['Due Time']), context: context, name: 'Due Time'),
            LinkCell(name: 'Submission', url: data['Submission'], context: context),
            ResourcesCell(name: 'Resources', resources: data['Resources'], context: context),
            DataCell(
              Row(
                children: [
                  IconButton(
                    key: const Key("editIcon"),
                    onPressed: () => EditDialog.showEditAssignmentDialog(
                      context: context,
                      initializeData: initializeData,
                      data: data,
                      courseController: courseController,
                      nameController: nameController,
                      typeController: typeController,
                      dueDateController: dueDateController,
                      dueTimeController: dueTimeController,
                      submissionController: submissionController,
                      resourcesController: resourcesController,
                    ),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    key: const Key("deleteIcon"),
                    onPressed: () => DeleteDialog.showDeleteConfirmationDialog(
                      context: context,
                      initializeData: initializeData,
                      data: data,
                    ),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
