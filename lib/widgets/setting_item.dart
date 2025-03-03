import 'package:idc_etus_bechar/widgets/forward_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';  // Import GetX for state management

class SettingItem extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final Function() onTap;
  final Widget? value;  // Change value type to Widget instead of String
  const SettingItem({
    super.key,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    required this.onTap,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          value ?? const SizedBox(),  // Use the widget or an empty space
          const SizedBox(width: 20),
          ForwardButton(
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

// Function to show language selection dialog
void _showLanguageSelection(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: const Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: _getCurrentLanguage(),
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text("English"),
                ),
                DropdownMenuItem(
                  value: 'es',
                  child: Text("Spanish"),
                ),
                DropdownMenuItem(
                  value: 'fr',
                  child: Text("French"),
                ),
              ],
              onChanged: (newValue) {
                if (newValue != null) {
                  _changeLanguage(newValue, context);
                  Navigator.pop(context);  // Close dialog after selection
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

// Function to get the current language
String _getCurrentLanguage() {
  return Get.locale?.languageCode ?? 'en'; // Default to English if no language is set
}

// Function to change the language
void _changeLanguage(String languageCode, BuildContext context) {
  Get.updateLocale(Locale(languageCode));
}

