import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracker_flutter/core/constants.dart';
import 'package:tracker_flutter/domain/models/category.dart';

class CategoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _collection => _db
      .collection(AppConstant.usersCollection)
      .doc(_auth.currentUser!.uid)
      .collection(AppConstant.categoriesCollection);

  Future<List<Category>> getAllCategories() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => Category.fromJson(doc.data())..id = doc.id)
        .toList();
  }

  Future<void> addCategory(Category category) async {
    await _collection.add(category.toJson());
  }
}
