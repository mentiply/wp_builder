import '../models/categoryModel/category_model.dart';
import '../models/postModel/post_model.dart';
import '../services/api.dart';

class WpRepsitory{
  final Api _api;
  WpRepsitory(this._api);

  Future<List<CategoryModel>> getCategory(int page) => _api.getCategory(page);

  Future<List<PostModel>> getLatestPost(int page) => _api.getLatestPost(page);

  Future<List<PostModel>> getPostByCategory(int id,int page) => _api.getPostByCategory(id, page);

  Future<List<PostModel>> searchPost(String searchText, int page) => _api.searchPost(searchText, page);

  Future<PostModel> getAboutUsPage(int pageId) => _api.getaboutUsPage(pageId);

}