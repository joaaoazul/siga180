import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/navigation_item.dart';

class BottomNavBar extends StatelessWidget {
  final List<NavigationItem> items;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const BottomNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Show only the most important items on mobile
    final mobileItems = [
      items[0], // Dashboard
      items[1], // Athletes
      items[2], // Workouts
      items[4], // Schedule
      items[7], // Settings
    ];

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _getMobileIndex(selectedIndex),
        onTap: (index) {
          // Map mobile index to actual index
          final actualIndex = _getActualIndex(index);
          onItemSelected(actualIndex);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryOlive,
        unselectedItemColor: AppColors.lightGray,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        items: mobileItems.map((item) => BottomNavigationBarItem(
          icon: Icon(item.icon),
          label: item.label,
        )).toList(),
      ),
    );
  }

  int _getMobileIndex(int actualIndex) {
    // Map actual index to mobile index
    switch (actualIndex) {
      case 0:
        return 0; // Dashboard
      case 1:
        return 1; // Athletes
      case 2:
        return 2; // Workouts
      case 4:
        return 3; // Schedule
      case 7:
        return 4; // Settings
      default:
        return 0;
    }
  }

  int _getActualIndex(int mobileIndex) {
    // Map mobile index to actual index
    switch (mobileIndex) {
      case 0:
        return 0; // Dashboard
      case 1:
        return 1; // Athletes
      case 2:
        return 2; // Workouts
      case 3:
        return 4; // Schedule
      case 4:
        return 7; // Settings
      default:
        return 0;
    }
  }
}