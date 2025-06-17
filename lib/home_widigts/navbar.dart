// import 'package:flutter/material.dart';
//
// class AppBottomNavigationBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;
//
//   const AppBottomNavigationBar({
//     super.key,
//     required this.selectedIndex,
//     required this.onItemTapped,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 70,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, -1),
//           ),
//         ],
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(15),
//           topRight: Radius.circular(15),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildNavBarItem(
//             icon: Icons.home,
//             label: 'الرئيسية',
//             index: 0,
//             context: context,
//           ),
//           _buildNavBarItem(
//             icon: Icons.search,
//             label: 'البحث',
//             index: 1,
//             context: context,
//           ),
//           _buildNavBarItem(
//             icon: Icons.person,
//             label: 'مساعدة',
//             index: 2,
//             context: context,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNavBarItem({
//     required IconData icon,
//     required String label,
//     required int index,
//     required BuildContext context,
//   }) {
//     bool isSelected = selectedIndex == index;
//
//     return GestureDetector(
//       onTap: () => onItemTapped(index),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         curve: Curves.easeInOut,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: isSelected
//             ? BoxDecoration(
//           color: const Color(0xFF8E9AFE).withOpacity(0.1),
//           borderRadius: BorderRadius.circular(15),
//         )
//             : null,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? const Color(0xFF8E9AFE) : Colors.grey[600],
//               size: 24,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 color: isSelected ? const Color(0xFF8E9AFE) : Colors.grey[700],
//                 fontSize: 12,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }