import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RapportCard extends StatelessWidget {
  final Map<String, dynamic> report;  // Accept report data

  const RapportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/images/prof_card_rapport.png'),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      "reference".tr,
                      style:const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "N°: ${report['bus_plate_number']}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 2),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,  // Center the text vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // Center the text horizontally
                    children: [
                      // Split the line name by spaces and display each word on a new line
                      ...?report['line_name']?.split(' ')?.map((word) {
                        return Text(
                          word,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10, // Adjust the size as needed
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                )

              ],
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Driver Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      "driver".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Check and display the driver name
                    ..._splitAndDisplayName(report['driver_name'] ?? 'Unknown'),
                  ],
                ),

                // Recipient Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                     Text(
                      "receiver".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Check and display the recipient name
                    ..._splitAndDisplayName(report['receiver_name'] ?? 'Unknown'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),

            // QR Code Placeholder
            Center(
              child: Container(
                height: 60,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black26,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.qr_code_2,
                  size: 60,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  List<Widget> _splitAndDisplayName(String driverName) {
    // Split the name by spaces
    List<String> nameParts = driverName.split(' ');

    // Check if there are multiple parts and display them on separate lines
    if (nameParts.length > 1) {
      return nameParts.map((part) {
        return Text(
          part,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        );
      }).toList();
    } else {
      // If it's a single word, just display it as is
      return [
        Text(
          nameParts[0],
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ];
    }
  }
}
