import '../models/breed_info_model.dart';
import '../models/knowledge_article_model.dart';

abstract class KnowledgeRepository {
  Future<List<BreedInfoModel>> getAllBreeds();
  Future<BreedInfoModel?> getBreedById(String id);
  Future<List<KnowledgeArticleModel>> getArticles();
  Future<void> toggleBookmarkArticle(String articleId);
}
