import 'package:idc_etus_bechar/utils/app_colors.dart';
import 'package:idc_etus_bechar/models/circle_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleWithLabel extends StatelessWidget {
  final CircleItem item;

  const CircleWithLabel({
    Key? key,
    required this.item
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circle with icon
        Container(
          height: 60.0,
          width: 60.0,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              item.imagePath,
              fit: BoxFit.contain,
              width: 30,
              height: 30,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Label below the circle
        Text(
          item.label,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
