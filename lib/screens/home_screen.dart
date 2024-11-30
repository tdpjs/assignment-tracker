import 'package:assignment_tracker/functionality_widgets/SortDropdown.dart';
import 'package:assignment_tracker/utils/sort_assignments.dart';
import 'package:assignment_tracker/welcome_text.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../functionality_widgets/ShowOverdue.dart';
import '../dialogs/add_dialog.dart';
import 'package:assignment_tracker/functionality_widgets/AssignmentsTable.dart';
import 'package:assignment_tracker/utils/filter_assignments.dart';

final supabase = Supabase.instance.client;

/// A Widget representing the main screen of the application
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
  final TextEditingController _sortController = TextEditingController();
  AssignmentsTable? _filteredDataTable;
  String? _errorMessage;
  bool _isLoading = false;
  String? displayName;

  /// Initial state of the home screen widget
  /// Checks if there is a current supabase session, if there isn't one, route back to
  /// the authentication screen, otherwise call the method to fetch user data from the database
  @override
  void initState() {
    super.initState();
    if (supabase.auth.currentSession == null) {
      Navigator.pushNamed(context, '/auth');
    } else {
      _initializeData();
    }
  }

  /// Fetch the current user's data from the database to the client
  /// and initialize the initial data to display in the table
  /// @returns true if the operation succeed and false otherwise
  Future<bool> _initializeData() async {
    setState(() {
      _errorMessage = null; // Reset error message.
      _isLoading = true;
    });
    try {
      final fetchSucceed = await _fetchUserData();
      if (!fetchSucceed) {
        setState(() {
          _errorMessage = "Fetch operation failed";
        });
        return false;
      }

      if (mounted) {
        setState(() {
          _applyFilters();
          _isLoading = false;
        });
        return true;
      }
      return false;
    } catch (error) {
      print('Error initializing data: $error');
      return false;
    }
  }

  /// Fetch the current user's data from the database to the client.
  /// @returns true if data is fetched successfully and false otherwise
  Future<bool> _fetchUserData() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      setState(() {
        _errorMessage = 'Error: User ID is null';
      });
      print(_errorMessage);
      return false;
    }

    try {
      final List<dynamic> response = await supabase
          .from('Assignments')
          .select()
          .eq('user_id', userId as Object);

      final identities = await supabase.auth.getUserIdentities();
      UserIdentity? identity = identities.lastOrNull;

      if (mounted) {
        setState(() {
          userData = List<Map<String, dynamic>>.from(response);

          if (identity != null) {
            displayName = identity.identityData?['name'] ?? identity.identityData?['email'] ?? "User";
          } else {
            displayName = "User";
          }

          _isLoading = false;
        });
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error fetching user data: $error');
      return false;
    }
  }

  /// Apply filters and update the tasks to be displayed.
  /// @return true if the operation is successful and false otherwise
  Future<bool> _applyFilters() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    try {
      final filteredData = filterData(
        currentData: userData,
        showOverdue: showOverdue,
        filters: _filterController.text,
      );
      final sortedData = sortData(
          currentData: filteredData,
          criteria: _sortController.text);
      final filteredDataTable = AssignmentsTable(
          context: context,
          courseController: courseController,
          nameController: nameController,
          typeController: typeController,
          dueDateController: dueDateController,
          dueTimeController: dueTimeController,
          submissionController: submissionController,
          resourcesController: resourcesController,
          initializeData: _initializeData,
          currentData: sortedData);
      setState(() {
        _filteredDataTable = filteredDataTable;
        _isLoading = false;
      });
      return true;
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: userData.isEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WelcomeAppBar(displayName: displayName),
            const Text(
              'Your Assignments',
              style: TextStyle(
                fontSize: 30,
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
            WelcomeAppBar(displayName: displayName),
            const Text(
              'Your Assignments',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Row(
                children: [
                  SortDropdown(applyFilters: _applyFilters,
                      sortController: _sortController),
                  Expanded(
                    child: TextFormField(
                      controller: _filterController,
                      decoration: InputDecoration(
                        labelText: 'Enter filters (e.g., course:Math type:Exam)',
                        errorText: _errorMessage,
                      ),
                      onFieldSubmitted: (value) => {
                        _applyFilters()
                      },
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
          Navigator.pushNamed(context, '/auth');
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}





