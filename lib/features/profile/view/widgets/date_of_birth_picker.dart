import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DateOfBirthPicker extends StatefulWidget {
  final Function(int)? onYearChanged;
  final int? initialYear;

  const DateOfBirthPicker({
    super.key,
    required this.onYearChanged,
    this.initialYear,
  });

  @override
  State<DateOfBirthPicker> createState() => _DateOfBirthPickerState();
}

class _DateOfBirthPickerState extends State<DateOfBirthPicker> {
  late int? selectedYear;
  final int currentYear = DateTime.now().year;
  final int startYear = DateTime.now().year - 100;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedYear,
          hint: Row(
            children: [
              const Icon(
                FontAwesomeIcons.calendarDays,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                'Chọn năm sinh',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          style: Theme.of(context).textTheme.bodyLarge,
          items: List.generate(
            currentYear - startYear,
            (index) {
              int year = startYear + index;
              return DropdownMenuItem(
                value: year,
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.calendarDays,
                      size: 16,
                    ),
                    const SizedBox(width: 20),
                    Text('$year'),
                  ],
                ),
              );
            },
          ),
          onChanged: (int? year) {
            if (year != null) {
              setState(() {
                selectedYear = year;
              });
              widget.onYearChanged?.call(year);
            }
          },
        ),
      ),
    );
  }
}
