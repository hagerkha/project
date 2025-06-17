//
//
//
//
//
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:authenticationapp/home_widigts/setting.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// // CustomDrawer - يمكنك إضافته أو استخدام الموجود
// class CustomDrawer extends StatelessWidget {
//   final String userName;
//   final String? userPhotoUrl;
//
//   const CustomDrawer({
//     Key? key,
//     required this.userName,
//     this.userPhotoUrl,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           DrawerHeader(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF8E9AFE), Color(0xFFB19CD7)],
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundImage: userPhotoUrl != null
//                       ? NetworkImage(userPhotoUrl!)
//                       : const AssetImage('images/default_profile.png') as ImageProvider,
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   userName,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings),
//             title: const Text('الإعدادات'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SettingsPage()),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text('تسجيل الخروج'),
//             onTap: () {
//               Navigator.pop(context);
//               FirebaseAuth.instance.signOut();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }