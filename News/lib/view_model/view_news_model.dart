import 'package:news/repository/new_repository.dart';
import 'package:news/models/category_news_model.dart';
import 'package:news/models/news_channel_headline_model.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi() async {
    final response = await _rep.fetchNewChannelHeadlinesApi();
    return response;
  }

  Future<CategoryNewsModel> fetchCategoriesNewsApi() async {
    final response = await _rep.fetchCategoriesNewsApi();
    return response;
  }
}
