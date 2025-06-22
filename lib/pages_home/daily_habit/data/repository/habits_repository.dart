import '../data_sources/habits_data_source.dart';
import '../model/habit_model.dart';

class HabitsRepository {
  final HabitsDataSource _dataSource;

  HabitsRepository(this._dataSource);

  List<HabitModel> getHabits() {
    return _dataSource.getHabits();
  }
}