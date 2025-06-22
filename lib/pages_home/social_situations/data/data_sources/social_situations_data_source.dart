import '../model/social_situation_model.dart';

class SocialSituationsDataSource {
  List<SocialSituationModel> getSocialSituations() {
    return SocialSituationModel.getSocialSituations();
  }
}