import 'package:local_basket/data/datasource/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_dataSource.dart';
import 'package:local_basket/data/model/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_model.dart';
import 'package:local_basket/domain/repository/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_repository.dart';

class GetMenuByRestaurantIdRepositoryImpl implements GetMenuByRestaurantIdRepository {
  final GetMenuByRestaurantIdRemoteDataSource remoteDataSource;

  GetMenuByRestaurantIdRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GetMenuByRestaurantIdModel> getMenuByRestaurantId(Map<String, dynamic> params) {
    return remoteDataSource.getMenuByRestaurantId(params);
  }
}
