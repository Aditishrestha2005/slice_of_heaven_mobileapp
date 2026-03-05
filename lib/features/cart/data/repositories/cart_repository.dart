import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slice_of_heaven/core/api/api_endpoints.dart';
import 'package:slice_of_heaven/core/error/failure.dart';
import 'package:slice_of_heaven/features/cart/data/datasources/cart_data_source.dart';
import 'package:slice_of_heaven/features/cart/data/datasources/local/cart_local_datasource.dart';
import 'package:slice_of_heaven/features/cart/data/models/cart_item_hive_model.dart';
import 'package:slice_of_heaven/features/cart/domain/entities/cart_item_entity.dart';
import 'package:slice_of_heaven/features/cart/domain/repositories/cart_repository.dart';

// Provider
final cartRepositoryProvider = Provider<ICartRepository>((ref) {
  final localDatasource = ref.read(cartLocalDatasourceProvider);
  return CartRepository(localDatasource: localDatasource);
});

class CartRepository implements ICartRepository {
  final ICartLocalDataSource _localDatasource;

  CartRepository({required ICartLocalDataSource localDatasource})
      : _localDatasource = localDatasource;

  // ✅ turn /uploads/... into full URL
  String _fullImageUrl(String image) {
    if (image.startsWith('http')) return image;
    return "${ApiEndpoints.baseUrl}$image";
  }

  // ✅ download and save to local storage (returns local path or null)
  Future<String?> _downloadAndSaveImage({
    required String pizzaId,
    required String imageUrl,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final cartDir = Directory("${dir.path}/cart_images");
      if (!await cartDir.exists()) {
        await cartDir.create(recursive: true);
      }

      // keep stable file name
      final filePath = "${cartDir.path}/$pizzaId.jpg";
      final file = File(filePath);

      // if already downloaded, reuse
      if (await file.exists() && await file.length() > 0) {
        return filePath;
      }

      final dio = Dio();
      final response = await dio.get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.data == null) return null;

      await file.writeAsBytes(response.data!, flush: true);
      return filePath;
    } catch (_) {
      return null; // if download fails, we still add item to cart without local image
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(CartItemEntity item) async {
    try {
      final imageUrl = _fullImageUrl(item.image);

      // ✅ try to save local image for offline
      final localPath = await _downloadAndSaveImage(
        pizzaId: item.pizzaId,
        imageUrl: imageUrl,
      );

      final updatedEntity = item.copyWith(localImagePath: localPath);

      final model = CartItemHiveModel.fromEntity(updatedEntity);
      await _localDatasource.addToCart(model);

      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    try {
      final models = await _localDatasource.getCartItems();
      final entities = CartItemHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(
    String pizzaId,
    int quantity,
  ) async {
    try {
      await _localDatasource.updateQuantity(pizzaId, quantity);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String pizzaId) async {
    try {
      await _localDatasource.removeFromCart(pizzaId);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await _localDatasource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}