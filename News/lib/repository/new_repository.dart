import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/models/category_news_model.dart';
import 'package:news/models/news_channel_headline_model.dart';

class NewsRepository {
  Future<NewsChannelsHeadlinesModel> fetchNewChannelHeadlinesApi() async {
    String url = 'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=f644ab03d8e04fc58a1c3f1c46befa7e';

    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
    // Added the missing URI parsing and await keyword
    // Handle the response here, e.g., check for success and parse the data
  }


  Future<CategoryNewsModel> fetchCategoriesNewsApi() async {
    String url = 'https://newsapi.org/v2/everything?q=general&apiKey=f644ab03d8e04fc58a1c3f1c46befa7e';

    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoryNewsModel.fromJson(body);
    }
    throw Exception('Error');
    // Added the missing URI parsing and await keyword
    // Handle the response here, e.g., check for success and parse the data
  }

}
