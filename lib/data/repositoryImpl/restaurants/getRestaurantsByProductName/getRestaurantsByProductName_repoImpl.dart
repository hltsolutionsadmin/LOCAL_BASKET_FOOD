import 'package:local_basket/data/datasource/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_dataSource.dart';
import 'package:local_basket/data/model/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_model.dart';
import 'package:local_basket/domain/repository/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_repository.dart';

class GetRestaurantsByProductNameRepositoryImpl implements GetRestaurantsByProductNameRepository {
  final GetRestaurantsByProductNameRemoteDataSource remoteDataSource;

  GetRestaurantsByProductNameRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GetRestaurantsByProductNameModel> getRestaurantsByProductName(Map<String, dynamic> params) {
    return remoteDataSource.getRestaurantsByProductName(params);
  }
}
