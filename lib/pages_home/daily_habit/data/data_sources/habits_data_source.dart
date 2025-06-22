import '../model/habit_model.dart';

class HabitsDataSource {
  List<HabitModel> getHabits() {
    return HabitModel.getHabits();
  }
}