import '../data_sources/interactive_data_source.dart';
import '../model/interactive_item_model.dart';

class InteractiveRepository {
  final InteractiveDataSource _dataSource;

  InteractiveRepository(this._dataSource);

  List<InteractiveItemModel> getInteractiveItems() {
    return _dataSource.getInteractiveItems();
  }
}