import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import 'category_state.dart';

@injectable
class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repository;
  StreamSubscription<List<Category>>? _categoriesSubscription;

  CategoryCubit(this._repository) : super(CategoryInitial());

  void listenToCategories(String userId) {
    emit(CategoryLoading());
    _categoriesSubscription?.cancel();
    _categoriesSubscription = _repository
        .getUserCategoriesStream(userId)
        .listen(
          (categories) => emit(CategoryLoaded(categories)),
          onError: (error) => emit(CategoryError(error.toString())),
        );
  }

  Future<void> addCategory(Category category) async {
    emit(CategoryLoading());
    try {
      final id = await _repository.addCategory(category);
      emit(CategoryAdded(id));
      // سيقوم الـ stream بتحديث القائمة تلقائياً
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    emit(CategoryLoading());
    try {
      await _repository.deleteCategory(categoryId);
      // Stream سيرسل القائمة الجديدة
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _categoriesSubscription?.cancel();
    return super.close();
  }
}
