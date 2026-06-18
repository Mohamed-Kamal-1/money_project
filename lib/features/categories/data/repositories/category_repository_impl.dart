import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

@Injectable(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final FirebaseFirestore _firestore;

  CategoryRepositoryImpl(this._firestore);

  @override
  Stream<List<Category>> getUserCategoriesStream(String userId) {
    return _firestore
        .collection('categories')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return Category(
              id: doc.id,
              userId: data['userId'] as String? ?? '',
              name: data['name'] as String? ?? '',
              icon: data['icon'] as String? ?? '',
              color: data['color'] as String? ?? '',
              type: data['type'] as String? ?? 'expense',
              createdAt:
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
              budget: data['budget'],
            );
          }).toList(),
        );
  }

  @override
  @override
  Future<String> addCategory(Category category) async {
    final docRef = _firestore.collection('categories').doc();
    await docRef.set({
      'userId': category.userId,
      'name': category.name,
      'icon': category.icon,
      'color': category.color,
      'type': category.type,
      'budget': category.budget, // ✅ يجب أن يكون موجوداً
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  @override
  Future<void> updateCategory(Category category) async {
    await _firestore.collection('categories').doc(category.id).update({
      'name': category.name,
      'icon': category.icon,
      'color': category.color,
      'budget': category.budget,
      'type': category.type,
    });
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await _firestore.collection('categories').doc(categoryId).delete();
  }
}
