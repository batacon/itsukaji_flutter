import 'package:flutter/material.dart';
import 'package:itsukaji_flutter/presentation/pages/activity_log_page.dart';
import 'package:itsukaji_flutter/presentation/pages/group_settings_page.dart';
import 'package:itsukaji_flutter/presentation/pages/settings_page.dart';
import 'package:itsukaji_flutter/presentation/pages/task_list_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const _screens = [
    TaskListPage(),
    ActivityLogPage(),
    GroupSettingsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (final int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
