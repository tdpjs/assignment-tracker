import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class SortDropdown extends StatefulWidget {
  final Future<void> Function() applyFilters;
  final TextEditingController sortController;

  const SortDropdown({
    Key? key,
    required this.applyFilters,
    required this.sortController,
  }) : super(key: key);

  @override
  State<SortDropdown> createState() => _SortDropdownState();
}

class _SortDropdownState extends State<SortDropdown> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Sort: ",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 300, // Adjust dropdown width
          child: DropdownButton<String>(
            value: widget.sortController.text.isNotEmpty ? widget.sortController.text : null,
            hint: const Text("Select", style: TextStyle(color: Colors.black)),
            items: const [
              DropdownMenuItem(
                value: "due_date",
                child: Text("Due Date (Ascending)", style: TextStyle(color: Colors.black)),
              ),
              DropdownMenuItem(
                value: "due_date_descending",
                child: Text("Due Date (Descending)", style: TextStyle(color: Colors.black)),
              ),
              DropdownMenuItem(
                value: "order_added",
                child: Text("Order Added (Ascending)", style: TextStyle(color: Colors.black)),
              ),
              DropdownMenuItem(
                value: "order_added_descending",
                child: Text("Order Added (Descending)", style: TextStyle(color: Colors.black)),
              ),
            ],
            onChanged: (value) async {
              if (value != null) {
                setState(() {
                  widget.sortController.text = value;
                });
                await widget.applyFilters();
              }
            },
          ),
        ),
      ],
    );
  }
}



