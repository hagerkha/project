// import 'dart:io';
// import 'dart:typed_data';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ProfileEditPage extends StatefulWidget {
// final String userName;
// final String? userPhotoUrl;
// final String initialName;
// final Function(String name, String? photoUrl)? onProfileUpdated;
//
// const ProfileEditPage({
// Key? key,
// required this.userName,
// this.userPhotoUrl,
// required this.initialName,
// this.onProfileUpdated,
// }) : super(key: key);
//
// @override
// _ProfileEditPageState createState() => _ProfileEditPageState();
// }
//
// class _ProfileEditPageState extends State<ProfileEditPage> {
// late TextEditingController _nameController;
// File? _image;
// Uint8List? _webImage;
// String? _networkImageUrl;
// int _selectedIndex = 2; // Default to profile tab (index 2)
//
// @override
// void initState() {
// super.initState();
// _nameController = TextEditingController(
// text: widget.initialName.isNotEmpty ? widget.initialName : widget.userName);
// _networkImageUrl = widget.userPhotoUrl;
// }
//
// @override
// void dispose() {
// _nameController.dispose();
// super.dispose();
// }
//
// Future<void> _pickImage() async {
// try {
// final ImagePicker picker = ImagePicker();
// final XFile? pickedImage = await picker.pickImage(
// source: ImageSource.gallery,
// maxWidth: 500,
// maxHeight: 500,
// imageQuality: 85,
// );
//
// if (pickedImage != null) {
// // Basic size validation (e.g., < 5MB)
// final bytes = await pickedImage.readAsBytes();
// if (bytes.length > 5 * 1024 * 1024) {
// throw Exception('حجم الصورة كبير جدًا (يجب أن يكون أقل من 5 ميجابايت)');
// }
//
// if (kIsWeb) {
// // For web platform
// setState(() {
// _webImage = bytes;
// _image = null;
// _networkImageUrl = null;
// });
// } else {
// // For mobile platforms
// setState(() {
// _image = File(pickedImage.path);
// _webImage = null;
// _networkImageUrl = null;
// });
// }
// }
// } catch (e) {
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(
// content: Text('خطأ في اختيار الصورة: ${e.toString()}'),
// backgroundColor: Colors.red,
// ),
// );
// }
// }
//
// Future<String?> _uploadImage() async {
// if (_image == null && _webImage == null) return null;
//
// try {
// final storageRef = FirebaseStorage.instance
//     .ref()
//     .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
//
// if (kIsWeb && _webImage != null) {
// // Upload for web
// await storageRef.putData(_webImage!);
// } else if (_image != null) {
// // Upload for mobile
// await storageRef.putFile(_image!);
// }
//
// // Get download URL
// return await storageRef.getDownloadURL();
// } catch (e) {
// throw Exception('خطأ في رفع الصورة: $e');
// }
// }
//
// Widget _buildProfileImage() {
// Widget imageWidget;
//
// if (kIsWeb && _webImage != null) {
// // Web platform with selected image
// imageWidget = Image.memory(
// _webImage!,
// width: 120,
// height: 120,
// fit: BoxFit.cover,
// );
// } else if (!kIsWeb && _image != null) {
// // Mobile platform with selected image
// imageWidget = Image.file(
// _image!,
// width: 120,
// height: 120,
// fit: BoxFit.cover,
// );
// } else if (_networkImageUrl != null && _networkImageUrl!.isNotEmpty) {
// // Network image
// imageWidget = Image.network(
// _networkImageUrl!,
// width: 120,
// height: 120,
// fit: BoxFit.cover,
// errorBuilder: (context, error, stackTrace) {
// return Image.asset(
// 'assets/images/default_profile.png',
// width: 120,
// height: 120,
// fit: BoxFit.cover,
// errorBuilder: (context, error, stackTrace) {
// return Container(
// width: 120,
// height: 120,
// decoration: BoxDecoration(
// color: Colors.grey[300],
// shape: BoxShape.circle,
// ),
// child: const Icon(
// Icons.person,
// size: 60,
// color: Colors.grey,
// ),
// );
// },
// );
// },
// );
// } else {
// // Default image
// imageWidget = Image.asset(
// 'assets/images/default_profile.png',
// width: 120,
// height: 120,
// fit: BoxFit.cover,
// errorBuilder: (context, error, stackTrace) {
// return Container(
// width: 120,
// height: 120,
// decoration: BoxDecoration(
// color: Colors.grey[300],
// shape: BoxShape.circle,
// ),
// child: const Icon(
// Icons.person,
// size: 60,
// color: Colors.grey,
// ),
// );
// },
// );
// }
//
// return ClipOval(child: imageWidget);
// }
//
// void _saveProfile() async {
// if (_nameController.text.trim().isEmpty) {
// ScaffoldMessenger.of(context).showSnackBar(
// const SnackBar(
// content: Text('يرجى إدخال الاسم'),
// backgroundColor: Colors.red,
// ),
// );
// return;
// }
//
// // Show loading
// showDialog(
// context: context,
// barrierDismissible: false,
// builder: (context) => const Center(
// child: CircularProgressIndicator(
// valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE6E6FA)),
// ),
// ),
// );
//
// try {
// // Save profile data
// String newName = _nameController.text.trim();
// String? newPhotoUrl = _networkImageUrl;
//
// // Upload new image if selected
// if (_image != null || _webImage != null) {
// newPhotoUrl = await _uploadImage();
// }
//
// if (widget.onProfileUpdated != null) {
// widget.onProfileUpdated!(newName, newPhotoUrl);
// }
//
// Navigator.of(context).pop(); // Close loading dialog
//
// ScaffoldMessenger.of(context).showSnackBar(
// const SnackBar(
// content: Text('تم حفظ التغييرات بنجاح!'),
// backgroundColor: Colors.green,
// ),
// );
//
// // Return to previous page (MainPage)
// await Future.delayed(const Duration(milliseconds: 500));
// Navigator.pop(context);
// } catch (e) {
// Navigator.of(context).pop(); // Close loading dialog
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(
// content: Text('خطأ في حفظ البيانات: ${e.toString()}'),
// backgroundColor: Colors.red,
// ),
// );
// }
// }
//
// void _onNavBarTap(int index) {
// if (index == _selectedIndex) return; // Avoid redundant navigation
//
// setState(() {
// _selectedIndex = index;
// });
//
// if (index == 0 || index == 1) {
// // Navigate to MainPage, passing the selected index
// Navigator.pushReplacementNamed(
// context,
// '/home',
// arguments: {'selectedIndex': index},
// );
// }
// }
//
// Widget _buildNavBarItem({
// required IconData icon,
// required String label,
// required int index,
// }) {
// bool isSelected = _selectedIndex == index;
//
// return GestureDetector(
// onTap: () => _onNavBarTap(index),
// child: AnimatedContainer(
// duration: const Duration(milliseconds: 200),
// curve: Curves.easeInOut,
// padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// decoration: isSelected
// ? BoxDecoration(
// color: const Color(0xFFE6E6FA).withOpacity(0.15),
// borderRadius: BorderRadius.circular(25),
// )
//     : null,
// child: Column(
// mainAxisSize: MainAxisSize.min,
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// AnimatedContainer(
// duration: const Duration(milliseconds: 200),
// curve: Curves.easeInOut,
// padding: const EdgeInsets.all(8),
// decoration: isSelected
// ? const BoxDecoration(
// color: Color(0xFFE6E6FA),
// borderRadius: BorderRadius.all(Radius.circular(15)),
// )
//     : null,
// child: Icon(
// icon,
// color: isSelected ? Colors.white : Colors.grey[600],
// size: 24,
// ),
// ),
// const SizedBox(height: 4),
// Text(
// label,
// style: TextStyle(
// color: isSelected ? const Color(0xFFE6E6FA) : Colors.grey[700],
// fontSize: 12,
// fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
// ),
// ),
// ],
// ),
// ),
// );
// }
//
// @override
// Widget build(BuildContext context) {
// return Scaffold(
// backgroundColor: Colors.white,
// appBar: AppBar(
// title: const Text(
// 'تعديل الملف الشخصي',
// style: TextStyle(
// fontSize: 22,
// fontWeight: FontWeight.w600,
// color: Colors.white,
// ),
// ),
// centerTitle: true,
// backgroundColor: const Color(0xFFE6E6FA),
// elevation: 0,
// iconTheme: const IconThemeData(color: Colors.white),
// ),
// body: Container(
// width: double.infinity,
// height: double.infinity,
// decoration: const BoxDecoration(
// gradient: LinearGradient(
// begin: Alignment.topCenter,
// end: Alignment.bottomCenter,
// colors: [
// Color(0xFFE6E6FA),
// Colors.white,
// ],
// stops: [0.0, 0.3],
// ),
// ),
// child: SingleChildScrollView(
// padding: const EdgeInsets.all(24),
// child: Column(
// children: [
// const SizedBox(height: 20),
//
// // Profile Image Section
// Container(
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// boxShadow: [
// BoxShadow(
// color: Colors.black.withOpacity(0.1),
// blurRadius: 20,
// offset: const Offset(0, 10),
// ),
// ],
// ),
// child: GestureDetector(
// onTap: _pickImage,
// child: Stack(
// children: [
// CircleAvatar(
// radius: 65,
// backgroundColor: Colors.white,
// child: CircleAvatar(
// radius: 60,
// backgroundColor: Colors.grey[200],
// child: _buildProfileImage(),
// ),
// ),
// Positioned(
// bottom: 5,
// right: 5,
// child: Container(
// padding: const EdgeInsets.all(8),
// decoration: BoxDecoration(
// color: const Color(0xFFE6E6FA),
// shape: BoxShape.circle,
// boxShadow: [
// BoxShadow(
// color: Colors.black.withOpacity(0.2),
// blurRadius: 8,
// offset: const Offset(0, 2),
// ),
// ],
// ),
// child: const Icon(
// Icons.camera_alt,
// color: Colors.white,
// size: 20,
// ),
// ),
// ),
// ],
// ),
// ),
// ),
//
// const SizedBox(height: 40),
//
// // Name Input Section
// Container(
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(15),
// boxShadow: [
// BoxShadow(
// color: Colors.grey.withOpacity(0.1),
// blurRadius: 10,
// offset: const Offset(0, 5),
// ),
// ],
// ),
// child: TextFormField(
// controller: _nameController,
// decoration: InputDecoration(
// labelText: 'الاسم',
// labelStyle: TextStyle(
// color: Colors.grey[600],
// fontSize: 16,
// ),
// prefixIcon: Icon(
// Icons.person_outline,
// color: const Color(0xFFE6E6FA),
// ),
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(15),
// borderSide: BorderSide.none,
// ),
// filled: true,
// fillColor: Colors.white,
// contentPadding: const EdgeInsets.symmetric(
// horizontal: 16,
// vertical: 16,
// ),
// ),
// style: const TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.w500,
// ),
// ),
// ),
//
// const SizedBox(height: 40),
//
// // Save Button
// Container(
// width: double.infinity,
// height: 56,
// decoration: BoxDecoration(
// gradient: const LinearGradient(
// colors: [
// Color(0xFFE6E6FA),
// Color(0xFF1E88E5), // Aligned with MainPage
// ],
// ),
// borderRadius: BorderRadius.circular(15),
// boxShadow: [
// BoxShadow(
// color: const Color(0xFFE6E6FA).withOpacity(0.3),
// blurRadius: 15,
// offset: const Offset(0, 8),
// ),
// ],
// ),
// child: ElevatedButton(
// onPressed: _saveProfile,
// style: ElevatedButton.styleFrom(
// backgroundColor: Colors.transparent,
// shadowColor: Colors.transparent,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(15),
// ),
// ),
// child: const Text(
// 'حفظ التغييرات',
// style: TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.w600,
// color: Colors.white,
// ),
// ),
// ),
// ),
//
// const SizedBox(height: 20),
// ],
// ),
// ),
// ),
// bottomNavigationBar: Container(
// height: 80,
// decoration: BoxDecoration(
// color: const Color(0xFFF0BBCD),
// boxShadow: [
// BoxShadow(
// color: Colors.grey.withOpacity(0.2),
// spreadRadius: 1,
// blurRadius: 10,
// offset: const Offset(0, -2),
// ),
// ],
// borderRadius: const BorderRadius.only(
// topLeft: Radius.circular(25),
// topRight: Radius.circular(25),
// ),
// ),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// _buildNavBarItem(
// icon: Icons.home,
// label: 'الرئيسية',
// index: 0,
// ),
// _buildNavBarItem(
// icon: Icons.search,
// label: 'البحث',
// index: 1,
// ),
// _buildNavBarItem(
// icon: Icons.person,
// label: 'الملف',
// index: 2,
// ),
// ],
// ),
// ),
// );
// }
// }
