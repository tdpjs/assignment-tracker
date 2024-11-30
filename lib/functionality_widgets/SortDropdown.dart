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
    return
      Expanded(
      child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 8),
        SizedBox(
          width: 300, // Adjust dropdown width
          child: DropdownButton<String>(
            value: widget.sortController.text.isNotEmpty ? widget.sortController.text : null,
            hint: const Text("Sort", style: TextStyle(color: Colors.black)),
              items: const [
                DropdownMenuItem(
                  value: "due_date",
                  child: Row(
                    children: [
                      Icon(Icons.arrow_upward, color: Colors.black),  // Ascending arrow
                      const SizedBox(width: 5),
                      const Text("Due Date", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "due_date_descending",
                  child: Row(
                    children: [
                      Icon(Icons.arrow_downward, color: Colors.black),  // Descending arrow
                      const SizedBox(width: 5),
                      const Text("Due Date", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "order_added",
                  child: Row(
                    children: [
                      Icon(Icons.arrow_upward, color: Colors.black),  // Ascending arrow
                      const SizedBox(width: 5),
                      const Text("Order Added", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "order_added_descending",
                  child: Row(
                    children: [
                      Icon(Icons.arrow_downward, color: Colors.black),  // Descending arrow
                      const SizedBox(width: 5),
                      const Text("Order Added", style: TextStyle(color: Colors.black)),
                    ],
                  ),
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
    )
    );
  }
}



