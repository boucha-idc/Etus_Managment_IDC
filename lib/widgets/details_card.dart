import 'package:flutter/material.dart';

class DetailsCard extends StatefulWidget {
  final String profileImage;
  final String firstText;
  final String secondText;
  final IconData icon;
  final VoidCallback onTap; // Callback for tap action

  const DetailsCard({
    super.key,
    required this.profileImage,
    required this.firstText,
    required this.secondText,
    required this.icon,
    required this.onTap, // Make onTap required
  });

  @override
  State<DetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onTap, // Handle the tap
      child: Container(
        height: 120,
        width:screenWidth ,
        padding: const EdgeInsets.only(left:16,top:16),
        decoration: BoxDecoration(
          image:const DecorationImage(
            image: AssetImage('assets/images/details_card.png'),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.profileImage),
              radius: 30,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.firstText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.secondText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: 62,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xff133E87).withOpacity(0.42),// Background color
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15), // Top-left rounded corner
                    bottomLeft: Radius.circular(15), // Bottom-left rounded corner
                  ),
                ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
