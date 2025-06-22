import '../data_sources/social_situations_data_source.dart';
import '../model/social_situation_model.dart';

class SocialSituationsRepository {
  final SocialSituationsDataSource _dataSource;

  SocialSituationsRepository(this._dataSource);

  List<SocialSituationModel> getSocialSituations() {
    return _dataSource.getSocialSituations();
  }
}