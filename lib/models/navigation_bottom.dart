import 'package:flutter/material.dart';

class NavigationBottom {
  final int id;
  final String activeIcon;
  final String inactiveIcon;
  final Widget screen;

  NavigationBottom({
    required this.id,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.screen,
  });
}
