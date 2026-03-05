import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';

import 'package:slice_of_heaven/core/services/connectivity/network_info.dart';

import 'package:slice_of_heaven/features/home/data/datasources/home_data_source.dart';
import 'package:slice_of_heaven/features/home/data/datasources/local/home_local_datasource.dart';
import 'package:slice_of_heaven/features/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:slice_of_heaven/features/home/data/models/pizza_api_model.dart';
import 'package:slice_of_heaven/features/home/data/models/pizza_hive_model.dart';
import 'package:slice_of_heaven/features/home/domain/entities/pizza_entity.dart';
import 'package:slice_of_heaven/features/home/domain/repositories/home_repository.dart';

// Provider
final homeRepositoryProvider = Provider<IHomeRepository>((ref) {
  final local = ref.read(homeLocalDatasourceProvider);
  final remote = ref.read(homeRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return HomeRepository(
    homeLocalDataSource: local,
    homeRemoteDataSource: remote,
    networkInfo: networkInfo,
  );
});

class HomeRepository implements IHomeRepository {
  final IHomeLocalDataSource _local;
  final IHomeRemoteDataSource _remote;
  final INetworkInfo _networkInfo;

  HomeRepository({
    required IHomeLocalDataSource homeLocalDataSource,
    required IHomeRemoteDataSource homeRemoteDataSource,
    required INetworkInfo networkInfo,
  })  : _local = homeLocalDataSource,
        _remote = homeRemoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<PizzaEntity>>> getAllPizzas() async {
    if (await _networkInfo.isConnected) {
      try {
        final List<PizzaApiModel> apiModels = await _remote.getAllPizzas();

        // cache in hive
        final List<PizzaHiveModel> hiveModels =
            apiModels.map((e) => e.toHiveModel()).toList();
        await _local.cachePizzas(hiveModels);

        // return entities
        final entities = apiModels.map((e) => e.toEntity()).toList();
        return Right(entities);
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        final data = e.response?.data;

        // ✅ show actual error
        return Left(
          ApiFailure(
            message: "Pizza API failed | status=$status | data=$data",
            statusCode: status,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      // offline -> cached
      try {
        final List<PizzaHiveModel> cached = await _local.getCachedPizzas();
        final entities = cached.map((e) => e.toEntity()).toList();

        if (entities.isEmpty) {
          return const Left(
            LocalDatabaseFailure(message: "No cached pizzas available"),
          );
        }

        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}