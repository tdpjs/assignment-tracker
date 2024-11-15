import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:assignment_tracker/filters.dart';

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

  @override
  void initState() {
    super.initState();
    if (supabase.auth.currentSession == null) {
      Navigator.pushNamed(context, '/auth');
    } else {
      _fetchUserData();
      _applyFilters();
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

  Future<void> _addAssignment() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      try {
        final List<String> resources = resourcesController.text
            .split(',')
            .map((s) => s.trim())
            .toList();

        await supabase.from('Assignments').insert({
          'user_id': userId,
          'Course': courseController.text,
          'Name': nameController.text,
          'Type': typeController.text,
          'Due Date': dueDateController.text,
          'Due Time': dueTimeController.text,
          'Submission': submissionController.text,
          'Resources': resources,
        });

        _fetchUserData();
        Navigator.of(context).pop();
      } catch (error) {
        print('Error adding assignment: $error');
      }
    }
  }

  Future<void> _editAssignment(Map<String, dynamic> data) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      try {
        final List<String> resources = resourcesController.text
            .split(',')
            .map((s) => s.trim())
            .toList();

        await supabase
            .from('Assignments')
            .update({
          'Course': courseController.text,
          'Name': nameController.text,
          'Type': typeController.text,
          'Due Date': dueDateController.text,
          'Due Time': dueTimeController.text,
          'Submission': submissionController.text,
          'Resources': resources,
        })
            .eq('id', data['id']);
        _fetchUserData();
        Navigator.of(context).pop();
      } catch (error) {
        print('Error updating assignment: $error');
      }
    }
  }

  Future<void> _deleteAssignment(Map<String, dynamic> data) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      try {
        await supabase
            .from('Assignments')
            .delete()
            .eq('id', data['id']);

        _fetchUserData();
        Navigator.of(context).pop();
      } catch (error) {
        print('Error deleting assignment: $error');
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  void _showAddAssignmentDialog() {
    courseController.clear();
    nameController.clear();
    typeController.clear();
    dueDateController.clear();
    dueTimeController.clear();
    submissionController.clear();
    resourcesController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text('Add Assignment'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: courseController,
                  decoration: const InputDecoration(labelText: 'Course'),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: typeController,
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                TextFormField(
                  controller: dueDateController,
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                    hintText: 'e.g. YYYY-MM-DD',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Due Date is required';
                    }
                    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                      return 'Enter a valid date (YYYY-MM-DD)';
                    }
                    return null;
                  },
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      dueDateController.text =
                          pickedDate.toIso8601String().split('T').first;
                    }
                  },
                ),
                TextFormField(
                  controller: dueTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Due Time',
                    hintText: 'HH:MM TZ',
                  ),
                  validator: (value) {
                    final timeRegEx = RegExp(
                      r'^(0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])\s?(AM|PM)?,?\s(IDLW|NST|HST|AKST|PST|MST|CST|EST|UTC|CET|EET|MSK|GST|PKT|BST|ICT|CST|JST|AEST|AEDT|NZST)$',
                    );
                    return (value == null || !timeRegEx.hasMatch(value))
                        ? 'Enter a valid time in HH:MM TZ format'
                        : null;
                  },
                ),
                TextFormField(
                  controller: submissionController,
                  decoration: const InputDecoration(
                    labelText: 'Submission URL',
                    hintText: 'Enter submission URL',
                  ),
                  keyboardType: TextInputType.url,
                ),
                TextFormField(
                  controller: resourcesController,
                  decoration: const InputDecoration(
                    labelText: 'Resources (comma-separated links)',
                    hintText: 'Enter resource links',
                  ),
                  maxLines: null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addAssignment();
                }
              },
              child: const Text('Add Assignment'),
            ),
          ],
        );
      },
    );
  }



  final _editFormKey = GlobalKey<FormState>();

  void _showEditAssignmentDialog(Map<String, dynamic> data) {
    courseController.text = data['Course'] ?? '';
    nameController.text = data['Name'] ?? '';
    typeController.text = data['Type'] ?? '';
    dueDateController.text = data['Due Date'] ?? '';
    dueTimeController.text = convertToTimeZoneFormat(data['Due Time'] ?? '');
    submissionController.text = data['Submission'] ?? '';
    resourcesController.text = data['Resources']?.join(', ') ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const Border(
            top: BorderSide(color: Color(0xFFDFDFDF)),
            left: BorderSide(color: Color(0xFFDFDFDF)),
            right: BorderSide(color: Color(0xFF7F7F7F)),
            bottom: BorderSide(color: Color(0xFF7F7F7F)),
          ),
          title: const Text('Edit Assignment'),
          content: Form(
            key: _editFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: courseController,
                  decoration: const InputDecoration(labelText: 'Course'),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? 'Name cannot be empty'
                        : null;
                  },
                ),
                TextFormField(
                  controller: typeController,
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                TextFormField(
                  controller: dueDateController,
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                    hintText: 'e.g. YYYY-MM-DD',
                  ),
                  validator: (value) {
                    final dateRegEx = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                    return (value == null || !dateRegEx.hasMatch(value))
                        ? 'Enter a valid date in YYYY-MM-DD format'
                        : null;
                  },
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      dueDateController.text =
                          pickedDate.toIso8601String().split('T').first;
                    }
                  },
                ),
                TextFormField(
                  controller: dueTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Due Time',
                    hintText: 'HH:MM TZ',
                  ),
                  validator: (value) {
                    final timeRegEx = RegExp(
                      r'^(0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])\s?(AM|PM)?,?\s(IDLW|NST|HST|AKST|PST|MST|CST|EST|UTC|CET|EET|MSK|GST|PKT|BST|ICT|CST|JST|AEST|AEDT|NZST)$',
                    );
                    return (value == null || !timeRegEx.hasMatch(value))
                        ? 'Enter a valid time in HH:MM TZ format'
                        : null;
                  },
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  controller: submissionController,
                  decoration: const InputDecoration(
                    labelText: 'Submission URL',
                    hintText: 'Enter submission URL',
                  ),
                  keyboardType: TextInputType.url,
                ),
                TextFormField(
                  controller: resourcesController,
                  decoration: const InputDecoration(
                    labelText: 'Resources (comma-separated links)',
                    hintText: 'Enter resource links',
                  ),
                  validator: (value) {
                    // Optional validation for URLs separated by commas.
                    if (value != null && value.isNotEmpty) {
                      for (var url in value.split(',')) {
                        if (!Uri.tryParse(url.trim())!.isAbsolute) {
                          return 'Each resource link must be a valid URL';
                        }
                      }
                    }
                    return null;
                  },
                  maxLines: null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_editFormKey.currentState?.validate() ?? false) {
                  _editAssignment(data);
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }


  void _showDeleteConfirmationDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const Border(
            top: BorderSide(color: Color(0xFFDFDFDF)),
            left: BorderSide(color: Color(0xFFDFDFDF)),
            right: BorderSide(color: Color(0xFF7F7F7F)),
            bottom: BorderSide(color: Color(0xFF7F7F7F)),
          ),
          title: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteAssignment(data);
              },
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                      color: Color.fromARGB(255, 240, 2, 2))),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  // Function to trigger filtering and update the DataTable.
  Future<void> _applyFilters() async {
    setState(() {
      _errorMessage = null; // Reset error message.
    });

    try {
      // Call the filtering function and update the DataTable.
      final filteredDataTable = await buildFilteredDataTable(
        _filterController.text,
      );
      setState(() {
        _filteredDataTable = filteredDataTable;
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
              onPressed: () => _showAddAssignmentDialog(),
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
                  )
                ],
              ),
            ),
            const SizedBox(height: 50),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _filteredDataTable
               ),
            const SizedBox(height: 20),
            FloatingActionButton.extended(
              heroTag: "Add Task",
              onPressed: () => _showAddAssignmentDialog(),
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

  Widget _buildCell(String? name, String? content) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200, maxHeight: 60),
      // Set max width and height
      child: GestureDetector(
          onDoubleTap: () =>
              _showCellDialog(name ?? 'Cell Content', content ?? '-'),
          onLongPress: () =>
              _showCellDialog(name ?? 'Cell Content', content ?? '-'),
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
        onDoubleTap: () => _showCellDialog(name ?? 'Time', formattedTime),
        onLongPress: () => _showCellDialog(name ?? 'Time', formattedTime),
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
        onLongPress: () => _showCellDialog(name ?? 'Submission', urlString),
        onDoubleTap: () => _showCellDialog(name ?? 'Submission', urlString),
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
        onLongPress: () => _showCellDialog(name ?? 'Submission', url),
        onDoubleTap: () => _showCellDialog(name ?? 'Submission', url),
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


// Show dialog for content on long press or double tap
  void _showCellDialog(String column, String content) {
    String? urlString = content.toString();
    if(Uri.tryParse(urlString)?.hasAbsolutePath == true) {
      showDialog(
        context: context,
        builder: (context) =>
        AlertDialog(
          title: Text(column),
          content: SingleChildScrollView(
            child:RichText(
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
            ), // Display the content of the cell in the dialog
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
    else {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text(column),
              content: SingleChildScrollView(
                child: Text(content)
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
      );
    }
  }

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

// Define a map for the timezone offsets.
  static const timezoneOffsets = {
    '-12': 'IDLW',
    '-11': 'NST',
    '-10': 'HST',
    '-09': 'AKST',
    '-08': 'PST',
    '-07': 'MST',
    '-06': 'CST',
    '-05': 'EST',
    '+00': 'UTC',
    '+01': 'CET',
    '+02': 'EET',
    '+03': 'MSK',
    '+04': 'GST',
    '+05': 'PKT',
    '+06': 'BST',
    '+07': 'ICT',
    '+08': 'CST',
    '+09': 'JST',
    '+10': 'AEST',
    '+11': 'AEDT',
    '+12': 'NZST',
  };

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
    final filteredData = await fetchDataWithFilters(
      course: courseFilter,
      name: nameFilter,
      type: typeFilter,
      timezone: timezoneFilter,
      fromDate: fromDate,
      toDate: toDate,
    );

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
            DataCell(_buildCell("Course", data['Course'])),
            DataCell(_buildCell("Name", data['Name'])),
            DataCell(_buildCell("Type", data['Type'])),
            DataCell(_buildCell("Due Date", data['Due Date'])),
            DataCell(_buildTimeCell(data['Due Time'], name: "Due Time")),
            DataCell(_buildLinkCell(data['Submission'])),
            DataCell(_buildResourcesCell(data['Resources'] ?? [])),
            DataCell(
              Row(
                children: [
                  IconButton(
                    onPressed: () => _showEditAssignmentDialog(data),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => _showDeleteConfirmationDialog(data),
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

  Future<List<Map<String, dynamic>>> fetchDataWithFilters({
    String? course,
    String? name,
    String? type,
    String? timezone,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    await _fetchUserData();
    List<Map<String, dynamic>> allData = userData;

    if ([course, name, type, timezone, fromDate, toDate].every((filter) => filter == null)) {
      return allData;
    }

    // Convert fromDate and toDate to UTC once.
    final fromDateUTC = fromDate != null && timezone != null
        ? convertToUTC(fromDate, timezone)
        : null;
    final toDateUTC = toDate != null && timezone != null
        ? convertToUTC(toDate, timezone)
        : null;

    return allData.where((data) {
      if (course != null && data['Course'] != course) return false;
      if (name != null && !data['Name'].contains(name)) return false;
      if (type != null && data['Type'] != type) return false;

      final dueDate = DateTime.parse(data['Due Date']);
      final dueDateUTC = timezone != null ? convertToUTC(dueDate, timezone) : dueDate.toUtc();

      if (fromDateUTC != null && dueDateUTC.isBefore(fromDateUTC)) return false;
      if (toDateUTC != null && dueDateUTC.isAfter(toDateUTC)) return false;

      return true;
    }).toList();
  }



  static const Map<String, double> stringToIntoffsets = {
    'ACDT': 10.5,
    'ACST': 9.5,
    'ACT': -5.0,
    'ACWST': 8.75,
    'ADT': -3.0,
    'AEDT': 11.0,
    'AEST': 10.0,
    'AFT': 4.5,
    'AKDT': -8.0,
    'AKST': -9.0,
    'ALMT': 6.0,
    'AMST': -3.0,
    'AMT': -4.0,
    'ANAST': 12.0,
    'ANAT': 12.0,
    'AQTT': 5.0,
    'ART': -3.0,
    'AST': 3.0,
    'AWDT': 9.0,
    'AWST': 8.0,
    'AZOST': 0.0,
    'AZOT': -1.0,
    'AZST': 5.0,
    'AZT': 4.0,
    'AoE': -12.0,
    'BNT': 8.0,
    'BOT': -4.0,
    'BRST': -2.0,
    'BRT': -3.0,
    'BST': 6.0,
    'BTT': 6.0,
    'CAST': 8.0,
    'CAT': 2.0,
    'CCT': 6.5,
    'CDT': -5.0,
    'CEST': 2.0,
    'CET': 1.0,
    'CHADT': 13.75,
    'CHAST': 12.75,
    'CHOST': 9.0,
    'CHOT': 8.0,
    'CHUT': 10.0,
    'CIST': -5.0,
    'CKT': -10.0,
    'CLST': -3.0,
    'CLT': -4.0,
    'COT': -5.0,
    'CST': -6.0,
    'CVT': -1.0,
    'CXT': 7.0,
    'ChST': 10.0,
    'DAVT': 7.0,
    'DDUT': 10.0,
    'EASST': -5.0,
    'EAST': -6.0,
    'EAT': 3.0,
    'ECT': -5.0,
    'EDT': -4.0,
    'EEST': 3.0,
    'EET': 2.0,
    'EGST': 0.0,
    'EGT': -1.0,
    'EST': -5.0,
    'ET': -5.0,
    'FET': 3.0,
    'FJST': 13.0,
    'FJT': 12.0,
    'FKST': -3.0,
    'FKT': -4.0,
    'FNT': -2.0,
    'GALT': -6.0,
    'GAMT': -9.0,
    'GET': 4.0,
    'GFT': -3.0,
    'GILT': 12.0,
    'GMT': 0.0,
    'GST': 4.0,
    'GYT': -4.0,
    'HKT': 8.0,
    'HST': -10.0,
    'IOT': 6.0,
    'IRDT': 4.5,
    'IRKST': 9.0,
    'IRKT': 8.0,
    'IRST': 3.5,
    'IST': 5.5,
    'JST': 9.0,
    'KGT': 6.0,
    'KOST': 11.0,
    'KRAST': 8.0,
    'KRAT': 7.0,
    'KST': 9.0,
    'KUYT': 4.0,
    'LHDT': 11.0,
    'LHST': 10.5,
    'LINT': 14.0,
    'MAGST': 12.0,
    'MAGT': 11.0,
    'MART': -9.5,
    'MAWT': 5.0,
    'MDT': -6.0,
    'MHT': 12.0,
    'MMT': 6.5,
    'MSD': 4.0,
    'MSK': 3.0,
    'MST': -7.0,
    'MUT': 4.0,
    'MVT': 5.0,
    'MYT': 8.0,
    'NCT': 11.0,
    'NDT': -2.5,
    'NFDT': 12.0,
    'NFT': 11.0,
    'NOVST': 7.0,
    'NOVT': 7.0,
    'NPT': 5.75,
    'NRT': 12.0,
    'NST': -3.5,
    'NUT': -11.0,
    'NZDT': 13.0,
    'NZST': 12.0,
    'OMSST': 7.0,
    'OMST': 6.0,
    'ORAT': 5.0,
    'PDT': -7.0,
    'PET': -5.0,
    'PETST': 12.0,
    'PETT': 12.0,
    'PGT': 10.0,
    'PHOT': 13.0,
    'PHT': 8.0,
    'PKT': 5.0,
    'PMDT': -2.0,
    'PMST': -3.0,
    'PONST': 11.0,
    'PST': -8.0,
    'PWT': 9.0,
    'PYST': -3.0,
    'PYT': -3.0,
    'QYZT': 6.0,
    'RET': 4.0,
    'ROTT': -3.0,
    'SAST': 2.0,
    'SBT': 11.0,
    'SCT': 4.0,
    'SGT': 8.0,
    'SRET': 11.0,
    'SRT': -3.0,
    'SST': -11.0,
    'SYOT': 3.0,
    'TAHT': -10.0,
    'TFT': 5.0,
    'TJT': 5.0,
    'TKT': 13.0,
    'TLT': 9.0,
    'TMT': 5.0,
    'TOST': 14.0,
    'TOT': 13.0,
    'TRT': 3.0,
    'TVT': 12.0,
    'ULAST': 9.0,
    'ULAT': 8.0,
    'UTC': 0.0,
    'UYST': -2.0,
    'UYT': -3.0,
    'UZT': 5.0,
    'VET': -4.0,
    'VLAST': 11.0,
    'VLAT': 10.0,
    'VOST': 6.0,
    'VUT': 11.0,
    'WAKT': 12.0,
    'WARST': -3.0,
    'WAST': 2.0,
    'WAT': 1.0,
    'WEST': 1.0,
    'WET': 0.0,
    'WFT': 12.0,
    'WIT': 9.0,
    'WST': 8.0,
    'WT': -7.0,
    'YAKT': 9.0,
    'YAKST': 10.0,
    'YEKT': 5.0,
  };

}





