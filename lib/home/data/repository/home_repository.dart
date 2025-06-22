import '../data_source/home_data_source.dart';
import '../model/course_model.dart';
import '../model/user_model.dart';

class HomeRepository {
  final HomeDataSource _dataSource;

  HomeRepository(this._dataSource);

  Future<List<CourseModel>> getCourses() async {
    return await _dataSource.fetchCourses();
  }

  Future<UserModel> getUserData() async {
    return await _dataSource.fetchUserData();
  }
}