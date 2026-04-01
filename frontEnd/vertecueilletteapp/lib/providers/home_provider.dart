import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/category_api.dart';
import '../api/product_api.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

final categoryApiProvider = Provider((ref) => CategoryApi());
final productApiProvider = Provider((ref) => ProductApi());

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final api = ref.read(categoryApiProvider);
  return await api.getCategories();
});

final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final api = ref.read(productApiProvider);
  return await api.getProducts();
});