import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'show_overdue.dart';
import 'dialogs/add_dialog.dart';
import 'dialogs/edit_dialog.dart';
import 'dialogs/delete_dialog.dart';
import 'constants.dart';
import 'functions/show_cell_dialog.dart';
import 'build_cells/build_resources_cell.dart';
import 'build_cells/build_submission_cell.dart';
import 'build_cells/build_text_cell.dart';
import 'build_cells/build_time_cell.dart';

final supabase = Supabase.instance.client;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> userData = [];
  final TextEditingController courseController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController dueTimeController = TextEditingController();
  final TextEditingController submissionController = TextEditingController();
  final TextEditingController resourcesController = TextEditingController();
  final TextEditingController _filterController = TextEditingController();
  DataTable? _filteredDataTable;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (supabase.auth.currentSession == null) {
      Navigator.pushNamed(context, '/auth');
    } else {
      _initializeData(); // Initialize data and apply filters
    }
  }

  Future<void> _initializeData() async {
    await _fetchUserData(); // Ensure data is fetched first
    if (mounted) {
      setState(() {
        _applyFilters(); // Apply filters after data is loaded
      });
    }
  }

  Future<void> _fetchUserData() async {
    final userId = supabase.auth.currentUser?.id;
    try {
      final List<dynamic> response = await supabase
          .from('Assignments')
          .select()
          .eq('user_id', userId as Object);

      if (mounted) {
        setState(() {
          // Handle both non-empty and empty states
          userData = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
      // Optionally, handle error state
      if (mounted) {
        setState(() {
          // Set some error state if needed, such as an error message or empty data
        });
      }
    }
  }

  // Function to trigger filtering and update the DataTable.
  Future<void> _applyFilters() async {
    setState(() {
      _errorMessage = null; // Reset error message.
      _isLoading = true;
    });
    try {
      // Call the filtering function and update the DataTable.
      final filteredDataTable = await buildFilteredDataTable(
        _filterController.text,
      );
      setState(() {
        _filteredDataTable = filteredDataTable;
        _isLoading = false;
      });
    } catch (error) {
      // Display error message if filter application fails.
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Assignments')),
      body: Center(
        child: userData.isEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Assignments',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            DataTable(
              columns: const [
                DataColumn(label: Text('Course')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Due Date')),
                DataColumn(label: Text('Due Time')),
                DataColumn(label: Text('Submission')),
                DataColumn(label: Text('Resources')),
                DataColumn(label: Text('Actions')),
              ],
              rows: const [],
            ),
            const SizedBox(height: 20),
            FloatingActionButton.extended(
              heroTag: "Add Task",
              onPressed: () => AddDialog.showAddAssignmentDialog(
                context: context,
                initializeData: _initializeData,
                courseController: courseController,
                nameController: nameController,
                typeController: typeController,
                dueDateController: dueDateController,
                dueTimeController: dueTimeController,
                submissionController: submissionController,
                resourcesController: resourcesController,
              ),
              //   onPressed: () => _showAddAssignmentDialog,
              icon: const Icon(Icons.add),
              label: const Text("Add Assignment"),
            ),
          ],
        )
            :
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Assignments',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _filterController,
                      decoration: InputDecoration(
                        labelText: 'Enter filters (e.g., course:Math type:Exam)',
                        errorText: _errorMessage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _applyFilters,
                    icon: const Icon(Icons.filter_alt),
                  ),
                  ShowOverdueCheckbox(applyFilters: _applyFilters)
                ],
              ),
            ),
            const SizedBox(height: 50),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _isLoading ? const CircularProgressIndicator() : _filteredDataTable
               ),
            const SizedBox(height: 20),
            FloatingActionButton.extended(
              heroTag: "Add Task",
              onPressed: () => AddDialog.showAddAssignmentDialog(
                context: context,
                initializeData: _initializeData,
                courseController: courseController,
                nameController: nameController,
                typeController: typeController,
                dueDateController: dueDateController,
                dueTimeController: dueTimeController,
                submissionController: submissionController,
                resourcesController: resourcesController
              ),
              // onPressed: () => _showAddAssignmentDialog(),
              icon: const Icon(Icons.add),
              label: const Text("Add Assignment"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "Log out",
        onPressed: () async {
          await supabase.auth.signOut();
          Navigator.pushNamed(context, '/');
        },
        child: const Icon(Icons.logout),
      ),
    );
  }

  Widget buildCell(String? name, String? content) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200, maxHeight: 60),
      // Set max width and height
      child: GestureDetector(
          onDoubleTap: () =>
              showCellDialog(context, name ?? 'Cell Content', content ?? '-'),
          onLongPress: () =>
              showCellDialog(context, name ?? 'Cell Content', content ?? '-'),
          child: RichText(
            text: TextSpan(
                text: content,
                style: const TextStyle(color: Colors.black)
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
      ),
    );
  }

  String? getOffset(String input) {
    var regex = RegExp(r'(\d{2}):(\d{2}):(\d{2})([+-]\d{1,2})');
    var match = regex.firstMatch(input);

    if (match == null) {
      return 'Invalid input format';
    }

    return match.group(4);
  }

  String convertToTimeZoneFormat(String input) {
    var regex = RegExp(r'(\d{2}):(\d{2}):(\d{2})([+-]\d{1,2})');
    var match = regex.firstMatch(input);

    if (match == null) {
      return 'Invalid input format';
    }

    String hour = match.group(1)!;
    String minute = match.group(2)!;
    String second = match.group(3)!;
    String timezoneOffset = match.group(4)!;

    // Combine the time string
    String timeString = '$hour:$minute:$second';
    DateTime time = DateFormat('HH:mm:ss').parse(timeString);

    // Convert to 12-hour format with AM/PM
    String formattedTime = DateFormat('hh:mm a').format(time);

    // Map the timezone offset to abbreviation
    String timezoneAbbreviation = getTimezoneAbbreviation(timezoneOffset);

    // Combine the formatted time and timezone abbreviation
    return '$formattedTime, $timezoneAbbreviation';
  }

  String getTimezoneAbbreviation(String offset) {
    return timezoneOffsets[offset] ?? 'Unknown';
  }

  Widget _buildTimeCell(String? timeString, {String? name}) {
    String formattedTime = 'Invalid Time';
    try {
      // Check if the timeString is valid and matches the expected format
      if (timeString != null && timeString.isNotEmpty) {
        formattedTime = convertToTimeZoneFormat(timeString);
      }
    } catch (e) {
      print("Error parsing time: $e");
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200, maxHeight: 60),
      child: GestureDetector(
        onDoubleTap: () => showCellDialog(context, name ?? 'Time', formattedTime),
        onLongPress: () => showCellDialog(context, name ?? 'Time', formattedTime),
        child: RichText(
          text: TextSpan(
            text: formattedTime,
            style: const TextStyle(color: Colors.black),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildLinkCell(dynamic url, {String? name}) {
    String? urlString = url?.toString();
    if (urlString != null && Uri
        .tryParse(urlString)
        ?.hasAbsolutePath == true) {
      return GestureDetector(
        onLongPress: () => showCellDialog(context, name ?? 'Submission', urlString),
        onDoubleTap: () => showCellDialog(context, name ?? 'Submission', urlString),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          // Limit width of cell
          child: RichText(
            text: TextSpan(
              text: urlString,
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final Uri uri = Uri.parse(urlString);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    print('Could not launch $uri');
                  }
                },
            ),
            maxLines: 1, // Limit text to one line
            overflow: TextOverflow.ellipsis, // Handle overflow
          ),
        ),
      );
    } else {
      return  GestureDetector(
        onLongPress: () => showCellDialog(context, name ?? 'Submission', url),
        onDoubleTap: () => showCellDialog(context, name ?? 'Submission', url),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          // Limit width of cell
          child: Text(url)
        ),
      );
    }
  }


// Build for the Resources Cell
  Widget _buildResourcesCell(dynamic resources) {
    if (resources == null || resources.isEmpty) {
      return const SelectableText('-');
    }

    // Ensure that resources is a list of strings
    List<String> validResources = [];

    if (resources is List) {
      validResources = resources.whereType<String>().toList(); // Filter out non-string items
    }

    // If validResources is empty, display a default message
    if (validResources.isEmpty) {
      return const SelectableText('No valid resources available');
    }

    return GestureDetector(
      onLongPress: () => _showResourcesDialog('Resources', validResources),
      onDoubleTap: () => _showResourcesDialog('Resources', validResources),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 3000, maxHeight: 120),
        child: SingleChildScrollView(
          child: Column(
            children: validResources.map<Widget>((resource) {
              return GestureDetector(
                onLongPress: () => _showResourcesDialog('Resource', validResources),
                onDoubleTap: () => _showResourcesDialog('Resource', validResources),
                child: _buildLinkCell(resource, name: ""),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }


// // Show dialog for content on long press or double tap
//   void showCellDialog(String column, String content) {
//     String? urlString = content.toString();
//     if(Uri.tryParse(urlString)?.hasAbsolutePath == true) {
//       showDialog(
//         context: context,
//         builder: (context) =>
//         AlertDialog(
//           title: Text(column),
//           content: SingleChildScrollView(
//             child:RichText(
//               text: TextSpan(
//                 text: urlString,
//                 style: const TextStyle(color: Colors.blue),
//                 recognizer: TapGestureRecognizer()
//                   ..onTap = () async {
//                     final Uri uri = Uri.parse(urlString);
//                     if (await canLaunchUrl(uri)) {
//                       await launchUrl(uri);
//                     } else {
//                       print('Could not launch $uri');
//                     }
//                   },
//               ),
//               maxLines: 1, // Limit text to one line
//               overflow: TextOverflow.ellipsis, // Handle overflow
//             ), // Display the content of the cell in the dialog
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Close'),
//             ),
//           ],
//         ),
//       );
//     }
//     else {
//       showDialog(
//         context: context,
//         builder: (context) =>
//             AlertDialog(
//               title: Text(column),
//               content: SingleChildScrollView(
//                 child: Text(content)
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: const Text('Close'),
//                 ),
//               ],
//             ),
//       );
//     }
//   }

  void _showResourcesDialog(String column, List<dynamic> content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(column),  // The name at the top of the dialog
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content.map((urlString) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: RichText(
                    text: TextSpan(
                      text: urlString,
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri uri = Uri.parse(urlString);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            print('Could not launch $uri');
                          }
                        },
                    ),
                    maxLines: 1, // Limit text to one line
                    overflow: TextOverflow.ellipsis, // Handle overflow
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<DataTable> buildFilteredDataTable(String? filters) async {
    // Initialize filter parameters.
    String? courseFilter, nameFilter, typeFilter, timezoneFilter;
    DateTime? fromDate, toDate;

    // Parse the filters string if provided.
    if (filters != null && filters.isNotEmpty) {
      final filterSegments = filters.split(' ');
      for (var segment in filterSegments) {
        if (segment.startsWith('course:')) {
          courseFilter = segment.split(':')[1];
        } else if (segment.startsWith('name:')) {
          nameFilter = segment.split(':')[1];
        } else if (segment.startsWith('type:')) {
          typeFilter = segment.split(':')[1];
        } else if (segment.startsWith('timezone:')) {
          timezoneFilter = segment.split(':')[1];
        } else if (segment.startsWith('from:')) {
          fromDate = DateTime.parse(segment.split(':')[1]);
        } else if (segment.startsWith('to:')) {
          toDate = DateTime.parse(segment.split(':')[1]);
        }
      }
    }

    if (fromDate != null || toDate != null) {
      if (timezoneFilter == null || timezoneFilter.isEmpty) {
        throw ArgumentError(
            'A timezone must be provided when using from and to.');
      }
    }

    // Fetch data from the database with the specified filters.
    final filteredData = filterData(
      course: courseFilter,
      name: nameFilter,
      type: typeFilter,
      timezone: timezoneFilter,
      fromDate: fromDate,
      toDate: toDate,
      showOverdue: showOverdue
    );
    print("Called");
    print(showOverdue);

    // Build the DataTable rows from the filtered data.
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
      rows: filteredData
          .map(
            (data) => DataRow(
          cells: [
            DataCell(buildCell("Course", data['Course'])),
            DataCell(buildCell("Name", data['Name'])),
            DataCell(buildCell("Type", data['Type'])),
            DataCell(buildCell("Due Date", data['Due Date'])),
            DataCell(_buildTimeCell(data['Due Time'], name: "Due Time")),
            DataCell(_buildLinkCell(data['Submission'])),
            DataCell(_buildResourcesCell(data['Resources'] ?? [])),
            DataCell(
              Row(
                children: [
                  IconButton(
                    onPressed: () => EditDialog.showEditAssignmentDialog(
                      context: context,
                      initializeData: _initializeData,
                      data: data,
                      courseController: courseController,
                      nameController: nameController,
                      typeController: typeController,
                      dueDateController: dueDateController,
                      dueTimeController: dueTimeController,
                      submissionController: submissionController,
                      resourcesController: resourcesController,
                    ),
                    // onPressed: () => _showEditAssignmentDialog,
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => DeleteDialog.showDeleteConfirmationDialog(
                      context: context,
                      initializeData: _initializeData,
                      data: data
                    ),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          .toList(),
    );
  }

  DateTime convertToUTC(DateTime localTime, String timezone) {

    // If the timezone is not found, throw an error.
    if (!stringToIntoffsets.containsKey(timezone)) {
      throw ArgumentError('Invalid timezone: $timezone');
    }

    // Get the timezone offset.
    int offset = stringToIntoffsets[timezone]! as int;

    // Convert the local time to UTC by adding/subtracting the offset
    // Local time is in the specified timezone, so adjust it to UTC
    return localTime.add(Duration(hours: offset));
  }

  /// Filters locally stored data based on the provided criteria.
  List<Map<String, dynamic>> filterData({
    String? course,
    String? name,
    String? type,
    String? timezone,
    DateTime? fromDate,
    DateTime? toDate,
    required bool showOverdue,
  }) {
    if ([course, name, type, timezone, fromDate, toDate].every((filter) => filter == null) && showOverdue) {
      return userData; // Return all data if no filters are provided
    }

    // Convert fromDate and toDate to UTC once.
    final fromDateUTC = fromDate != null && timezone != null
        ? convertToUTC(fromDate, timezone)
        : null;
    final toDateUTC = toDate != null && timezone != null
        ? convertToUTC(toDate, timezone)
        : null;

    // Get the current UTC time.
    final currentUTC = DateTime.now().toUtc();

    return userData.where((data) {
      // Filter by course.
      if (course != null && data['Course'] != course) return false;

      // Filter by name (partial match).
      if (name != null && !data['Name'].contains(name)) return false;

      // Filter by type.
      if (type != null && data['Type'] != type) return false;

      // Parse the due date and time.
      final dueDate = DateTime.parse(data['Due Date']);
      final dueDateUTC = timezone != null ? convertToUTC(dueDate, timezone) : dueDate.toUtc();

      // Filter by fromDate and toDate.
      if (fromDateUTC != null && dueDateUTC.isBefore(fromDateUTC)) return false;
      if (toDateUTC != null && dueDateUTC.isAfter(toDateUTC)) return false;

      // If showOverdue is false, filter out overdue tasks.
      if (!showOverdue && dueDateUTC.isBefore(currentUTC)) return false;

      return true;
    }).toList();
  }
}





