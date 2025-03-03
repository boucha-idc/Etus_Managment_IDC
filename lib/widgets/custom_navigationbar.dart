import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:idc_etus_bechar/utils/app_colors.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  CustomNavigationBar({
    required this.currentIndex,
    required this.onTabSelected,
  });

  final List<Map<String, String>> navBtn = [
    {
      'activeIcon': 'assets/icon/home.svg',
      'inactiveIcon': 'assets/icon/home.svg',
    },
    {
      'activeIcon': 'assets/icon/bus.svg',
      'inactiveIcon': 'assets/icon/bus.svg',
    },
    {
      'activeIcon': 'assets/icon/profils.svg',
      'inactiveIcon': 'assets/icon/profils.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE3E8F2),
        borderRadius: BorderRadius.circular(65.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navBtn.length, (index) {
          bool isActive = index == currentIndex;
          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  isActive ? navBtn[index]['activeIcon']! : navBtn[index]['inactiveIcon']!,
                  color: isActive ? AppColors.primary : Colors.black,
                  height: 30.0,
                  width: 30.0,
                ),
                if (isActive) const SizedBox(height: 5),
                if (isActive)
                  Container(
                    height: 5,
                    width: 30,
                    color: AppColors.primary,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
