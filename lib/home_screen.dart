import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    super.initState();
    if (supabase.auth.currentSession == null) {
      Navigator.pushNamed(context, '/auth');
    } else {
      _fetchUserData();
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

  // void _showAddAssignmentDialog() {
  //   courseController.clear();
  //   nameController.clear();
  //   typeController.clear();
  //   dueDateController.clear();
  //   dueTimeController.clear();
  //   submissionController.clear();
  //   resourcesController.clear();
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: const Border(
  //           top: BorderSide(color: Color(0xFFDFDFDF)),
  //           left: BorderSide(color: Color(0xFFDFDFDF)),
  //           right: BorderSide(color: Color(0xFF7F7F7F)),
  //           bottom: BorderSide(color: Color(0xFF7F7F7F)),
  //         ),
  //         title: const Text('Add Assignment'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: courseController,
  //               decoration: const InputDecoration(labelText: 'Course'),
  //             ),
  //             TextField(
  //               controller: nameController,
  //               decoration: const InputDecoration(labelText: 'Name'),
  //             ),
  //             TextField(
  //               controller: typeController,
  //               decoration: const InputDecoration(labelText: 'Type'),
  //             ),
  //             TextField(
  //               controller: dueDateController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Due Date',
  //                 hintText: 'e.g. YYYY-MM-DD',
  //               ),
  //               onTap: () async {
  //                 FocusScope.of(context).requestFocus(FocusNode());
  //                 DateTime? pickedDate = await showDatePicker(
  //                   context: context,
  //                   initialDate: DateTime.now(),
  //                   firstDate: DateTime(2000),
  //                   lastDate: DateTime(2101),
  //                 );
  //                 if (pickedDate != null) {
  //                   dueDateController.text =
  //                       pickedDate
  //                           .toIso8601String()
  //                           .split('T')
  //                           .first;
  //                 }
  //               },
  //             ),
  //             TextField(
  //               controller: dueTimeController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Due Time',
  //                 hintText: 'HH:MM TZ',
  //               ),
  //               keyboardType: TextInputType.datetime,
  //             ),
  //             TextField(
  //               controller: submissionController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Submission URL',
  //                 hintText: 'Enter submission URL',
  //               ),
  //               keyboardType: TextInputType.url,
  //             ),
  //             TextField(
  //               controller: resourcesController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Resources (comma-separated links)',
  //                 hintText: 'Enter resource links',
  //               ),
  //               maxLines: null,
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: _addAssignment,
  //             child: const Text('Add Assignment'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  // void _showEditAssignmentDialog(Map<String, dynamic> data) {
  //   courseController.text = data['Course'] ?? '';
  //   nameController.text = data['Name'] ?? '';
  //   typeController.text = data['Type'] ?? '';
  //   dueDateController.text = data['Due Date'] ?? '';
  //   dueTimeController.text = data['Due Time'] ?? '';
  //   submissionController.text = data['Submission'] ?? '';
  //   resourcesController.text = data['Resources']?.join(', ') ?? '';
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: const Border(
  //           top: BorderSide(color: Color(0xFFDFDFDF)),
  //           left: BorderSide(color: Color(0xFFDFDFDF)),
  //           right: BorderSide(color: Color(0xFF7F7F7F)),
  //           bottom: BorderSide(color: Color(0xFF7F7F7F)),
  //         ),
  //         title: const Text('Edit Assignment'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: courseController,
  //               decoration: const InputDecoration(labelText: 'Course'),
  //             ),
  //             TextField(
  //               controller: nameController,
  //               decoration: const InputDecoration(labelText: 'Name'),
  //             ),
  //             TextField(
  //               controller: typeController,
  //               decoration: const InputDecoration(labelText: 'Type'),
  //             ),
  //             TextField(
  //               controller: dueDateController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Due Date',
  //                 hintText: 'e.g. YYYY-MM-DD',
  //               ),
  //               onTap: () async {
  //                 FocusScope.of(context).requestFocus(FocusNode());
  //                 DateTime? pickedDate = await showDatePicker(
  //                   context: context,
  //                   initialDate: DateTime.now(),
  //                   firstDate: DateTime(2000),
  //                   lastDate: DateTime(2101),
  //                 );
  //                 if (pickedDate != null) {
  //                   dueDateController.text =
  //                       pickedDate
  //                           .toIso8601String()
  //                           .split('T')
  //                           .first;
  //                 }
  //               },
  //             ),
  //             TextField(
  //               controller: dueTimeController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Due Time',
  //                 hintText: 'HH:MM TZ',
  //               ),
  //               keyboardType: TextInputType.datetime,
  //             ),
  //             TextField(
  //               controller: submissionController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Submission URL',
  //                 hintText: 'Enter submission URL',
  //               ),
  //               keyboardType: TextInputType.url,
  //             ),
  //             TextField(
  //               controller: resourcesController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Resources (comma-separated links)',
  //                 hintText: 'Enter resource links',
  //               ),
  //               maxLines: null,
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               _editAssignment(data);
  //             },
  //             child: const Text('Save Changes'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:
            DataTable(
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
              rows: userData
                  .map(
                    (data) =>
                    DataRow(cells: [
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
                              onPressed: () =>
                                  _showDeleteConfirmationDialog(data),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ).toList(),
            )),
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

  String convertToTimeZoneFormat(String input) {
    var regex = RegExp(r'(\d{2}):(\d{2}):(\d{2})([+-]\d{2})');
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
    Map<String, String> timezoneMap = {
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

    return timezoneMap[offset] ?? 'Unknown';
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

}
