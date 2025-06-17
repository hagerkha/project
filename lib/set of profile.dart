// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ProfileEditPage extends StatefulWidget {
//   final String userName;
//   final String? userPhotoUrl;
//   final String initialName;
//   final Function(String name, String? photoUrl)? onProfileUpdated;
//
//   const ProfileEditPage({
//     Key? key,
//     required this.userName,
//     this.userPhotoUrl,
//     required this.initialName,
//     this.onProfileUpdated,
//   }) : super(key: key);
//
//   @override
//   _ProfileEditPageState createState() => _ProfileEditPageState();
// }
//
// class _ProfileEditPageState extends State<ProfileEditPage>
//     with TickerProviderStateMixin {
//   late TextEditingController _nameController;
//   File? _image;
//   Uint8List? _webImage;
//   String? _networkImageUrl;
//
//   // Animation controllers
//   late AnimationController _fadeController;
//   late AnimationController _scaleController;
//   late AnimationController _slideController;
//
//   // Animations
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _buttonScaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(
//         text: widget.initialName.isNotEmpty ? widget.initialName : widget.userName
//     );
//     _networkImageUrl = widget.userPhotoUrl;
//
//     // Initialize animation controllers
//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//
//     _scaleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//
//     _slideController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//
//     // Setup animations
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );
//
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
//     );
//
//     _buttonScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.bounceOut),
//     );
//
//     // Start animations
//     _startAnimations();
//   }
//
//   void _startAnimations() async {
//     await Future.delayed(const Duration(milliseconds: 100));
//     _fadeController.forward();
//     await Future.delayed(const Duration(milliseconds: 200));
//     _scaleController.forward();
//     await Future.delayed(const Duration(milliseconds: 100));
//     _slideController.forward();
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _fadeController.dispose();
//     _scaleController.dispose();
//     _slideController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage() async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? pickedImage = await picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 500,
//         maxHeight: 500,
//         imageQuality: 85,
//       );
//
//       if (pickedImage != null) {
//         if (kIsWeb) {
//           // For web platform
//           final bytes = await pickedImage.readAsBytes();
//           setState(() {
//             _webImage = bytes;
//             _image = null;
//             _networkImageUrl = null;
//           });
//         } else {
//           // For mobile platforms
//           setState(() {
//             _image = File(pickedImage.path);
//             _webImage = null;
//             _networkImageUrl = null;
//           });
//         }
//
//         // Animate image change
//         _scaleController.reset();
//         _scaleController.forward();
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('خطأ في اختيار الصورة: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   Widget _buildProfileImage() {
//     Widget imageWidget;
//
//     if (kIsWeb && _webImage != null) {
//       // Web platform with selected image
//       imageWidget = Image.memory(
//         _webImage!,
//         width: 120,
//         height: 120,
//         fit: BoxFit.cover,
//       );
//     } else if (!kIsWeb && _image != null) {
//       // Mobile platform with selected image
//       imageWidget = Image.file(
//         _image!,
//         width: 120,
//         height: 120,
//         fit: BoxFit.cover,
//       );
//     } else if (_networkImageUrl != null && _networkImageUrl!.isNotEmpty) {
//       // Network image
//       imageWidget = Image.network(
//         _networkImageUrl!,
//         width: 120,
//         height: 120,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           return Image.asset(
//             '/images/default_profile.png',
//             width: 120,
//             height: 120,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) {
//               return Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.person,
//                   size: 60,
//                   color: Colors.grey,
//                 ),
//               );
//             },
//           );
//         },
//       );
//     } else {
//       // Default image
//       imageWidget = Image.asset(
//         '/images/default_profile.png',
//         width: 120,
//         height: 120,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           return Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.person,
//               size: 60,
//               color: Colors.grey,
//             ),
//           );
//         },
//       );
//     }
//
//     return ClipOval(child: imageWidget);
//   }
//
//   void _saveProfile() async {
//     if (_nameController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('يرجى إدخال الاسم'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     // Show loading
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B7ED3)),
//         ),
//       ),
//     );
//
//     try {
//       // Save profile data
//       String newName = _nameController.text.trim();
//
//       if (widget.onProfileUpdated != null) {
//         widget.onProfileUpdated!(newName, _networkImageUrl);
//       }
//
//       await Future.delayed(const Duration(milliseconds: 500)); // Simulate saving
//
//       Navigator.of(context).pop(); // Close loading dialog
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('تم حفظ التغييرات بنجاح!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//
//       // Navigate to home - try multiple methods to ensure it works
//       await Future.delayed(const Duration(milliseconds: 500));
//
//       // Method 1: Try named route
//       try {
//         Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
//       } catch (e) {
//         // Method 2: Try alternative home route names
//         try {
//           Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
//         } catch (e) {
//           // Method 3: Pop until home (go back to previous screens)
//           Navigator.of(context).popUntil((route) => route.isFirst);
//         }
//       }
//
//     } catch (e) {
//       Navigator.of(context).pop(); // Close loading dialog
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('خطأ في حفظ البيانات: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'تعديل الملف الشخصي',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF9B7ED3),
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: AnimatedBuilder(
//         animation: Listenable.merge([_fadeController, _scaleController, _slideController]),
//         builder: (context, child) {
//           return Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color(0xFF9B7ED3),
//                   Colors.white,
//                 ],
//                 stops: [0.0, 0.3],
//               ),
//             ),
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: SlideTransition(
//                   position: _slideAnimation,
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 20),
//
//                       // Profile Image Section
//                       ScaleTransition(
//                         scale: _scaleAnimation,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 10),
//                               ),
//                             ],
//                           ),
//                           child: GestureDetector(
//                             onTap: _pickImage,
//                             child: Stack(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 65,
//                                   backgroundColor: Colors.white,
//                                   child: CircleAvatar(
//                                     radius: 60,
//                                     backgroundColor: Colors.grey[200],
//                                     child: _buildProfileImage(),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: 5,
//                                   right: 5,
//                                   child: Container(
//                                     padding: const EdgeInsets.all(8),
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFF9B7ED3),
//                                       shape: BoxShape.circle,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black.withOpacity(0.2),
//                                           blurRadius: 8,
//                                           offset: const Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: const Icon(
//                                       Icons.camera_alt,
//                                       color: Colors.white,
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 40),
//
//                       // Name Input Section
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.1),
//                               blurRadius: 10,
//                               offset: const Offset(0, 5),
//                             ),
//                           ],
//                         ),
//                         child: TextFormField(
//                           controller: _nameController,
//                           decoration: InputDecoration(
//                             labelText: 'الاسم',
//                             labelStyle: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 16,
//                             ),
//                             prefixIcon: Icon(
//                               Icons.person_outline,
//                               color: const Color(0xFF9B7ED3),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide.none,
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 16,
//                             ),
//                           ),
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 40),
//
//                       // Save Button
//                       ScaleTransition(
//                         scale: _buttonScaleAnimation,
//                         child: Container(
//                           width: double.infinity,
//                           height: 56,
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [
//                                 Color(0xFF9B7ED3),
//                                 Color(0xFF7E16EE),
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(15),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color(0xFF9B7ED3).withOpacity(0.3),
//                                 blurRadius: 15,
//                                 offset: const Offset(0, 8),
//                               ),
//                             ],
//                           ),
//                           child: ElevatedButton(
//                             onPressed: _saveProfile,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               shadowColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                             child: const Text(
//                               'حفظ التغييرات',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
