import '../entities/category.dart';

abstract interface class CategoryRepository {
  Stream<List<Category>> getUserCategoriesStream(String userId);
  Future<String> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String categoryId);
}
