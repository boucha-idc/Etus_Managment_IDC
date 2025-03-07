import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idc_etus_bechar/view/admin/bus_situation.dart';
import 'package:idc_etus_bechar/view/admin/main_screen.dart';
import 'package:idc_etus_bechar/view/admin/worker_details.dart';
import 'package:idc_etus_bechar/widgets/custom_navigationbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args['index'] != null) {
      _currentIndex = args['index'];
    }
  }
  final List<Widget> _screens = [
    MainScreen(),
    BusSituation(),
    WorkerDetails(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F5),
      body: IndexedStack(  // Keeps state of each screen
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
