import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:idc_etus_bechar/controller/bus_rapport_controller.dart';

class DropdownOptionWidget extends StatelessWidget {
  final BusRapportController controller;
  final List<String> options;
  final RxString selectedValue;
  final String label;
  final Function(String?) onChanged;

  DropdownOptionWidget({
    required this.controller,
    required this.options,
    required this.selectedValue,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Obx(() {
          // Show loading spinner when data is being fetched
          if (controller.isLoading.value || options.isEmpty) {
            return Center(
              child: SpinKitThreeBounce(
                color: Colors.black,
                size: 20.0,
              ),
            );
          }

          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue.value.isEmpty ? null : selectedValue.value,
              hint: Text(
                label,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (newValue) {
                selectedValue.value = newValue ?? ''; // Directly update the RxString
                onChanged(newValue); // Call the onChanged callback
              },
              dropdownColor: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        }),
      ),
    );
  }
}
