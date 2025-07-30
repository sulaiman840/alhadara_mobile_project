import 'ad_model.dart';

class AdsPageModel {
  final List<AdModel> ads;
  final int currentPage, lastPage, total;

  AdsPageModel({
    required this.ads,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory AdsPageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final list = (data['data'] as List)
        .cast<Map<String, dynamic>>()
        .map((e) => AdModel.fromJson(e))
        .toList();
    return AdsPageModel(
      ads: list,
      currentPage: data['current_page'] as int,
      lastPage: data['last_page'] as int,
      total: data['total'] as int,
    );
  }
}
