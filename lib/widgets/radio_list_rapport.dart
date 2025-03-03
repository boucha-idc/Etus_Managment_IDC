import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idc_etus_bechar/utils/app_colors.dart';
class HorizontalRadioList extends StatelessWidget {
  final List<String> options; // List of options
  final String selectedOption; // Currently selected option
  final Function(String) onSelectionChanged; // Callback to update selected option

  const HorizontalRadioList({
    Key? key,
    required this.options,
    required this.selectedOption,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Wrap Row in SingleChildScrollView to allow horizontal scrolling
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: Row(
        children: options.map((option) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Radio<String>(
                  value: option,
                  groupValue: selectedOption,
                  activeColor: AppColors.primary, // Set active color to blue
                  onChanged: (String? value) {
                    if (value != null) {
                      onSelectionChanged(value); // Call the callback with the new value
                    }
                  },
                ),
                Text(
                  option,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
