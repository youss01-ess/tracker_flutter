import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tracker_flutter/data/services/category_service.dart';
import 'package:tracker_flutter/domain/models/category.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  final CategoryService _categoryService = CategoryService();
  List<Category> get categories => _categories;

  Future<void> fetchCategories() async {
    try {
      _categories = await _categoryService.getAllCategories();
    } catch (e) {
      log('Error fetching categories: $e');
    }
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    try {
      await _categoryService.addCategory(category);
      await fetchCategories();
    } catch (e) {
      log('Error adding category: $e');
    }
  }
}
