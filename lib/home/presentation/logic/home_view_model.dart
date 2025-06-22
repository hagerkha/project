import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/course_model.dart';
import '../../data/model/user_model.dart';
import '../../data/repository/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository;
  List<CourseModel> _courses = [];
  UserModel _user = UserModel(name: 'مستخدم', photoUrl: null, email: null);
  bool _isLoading = true;
  String _searchQuery = '';
  List<CourseModel> _filteredCourses = [];

  HomeViewModel(this._repository) {
    _fetchInitialData();
  }

  List<CourseModel> get courses => _courses;
  UserModel get user => _user;
  bool get isLoading => _isLoading;
  List<CourseModel> get filteredCourses => _filteredCourses;

  String get searchQuery => _searchQuery;
  set searchQuery(String query) {
    _searchQuery = query;
    _filterCourses();
    notifyListeners();
  }

  Future<void> _fetchInitialData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _courses = await _repository.getCourses();
      _filteredCourses = _courses;
      _user = await _repository.getUserData();
    } catch (e) {
      print('Error fetching data: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  void _filterCourses() {
    if (_searchQuery.isEmpty) {
      _filteredCourses = _courses;
    } else {
      _filteredCourses = _courses.where((course) =>
      course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.subtitle.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    notifyListeners();
  }

  void navigateToRoute(BuildContext context, String routeName) {
    // تنقل باستخدام Navigator
  }
}