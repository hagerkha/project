import '../model/interactive_item_model.dart';

class InteractiveDataSource {
  List<InteractiveItemModel> getInteractiveItems() {
    return InteractiveItemModel.getInteractiveItems();
  }
}