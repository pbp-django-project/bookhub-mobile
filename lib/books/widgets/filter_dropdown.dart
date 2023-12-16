import 'package:flutter/material.dart';

/// Flutter code sample for [DropdownButton].

const List<String> list = <String>['All', 'Title', 'Author', 'Pub Year'];


class FilterButton extends StatefulWidget {
  const FilterButton({super.key});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 3),
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 6,
      style: const TextStyle(color: Colors.teal),
      underline: Container(
        height: 3,
        color: Colors.teal,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
