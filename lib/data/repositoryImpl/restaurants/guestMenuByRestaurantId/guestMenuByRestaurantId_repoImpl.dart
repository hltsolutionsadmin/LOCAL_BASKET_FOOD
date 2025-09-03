import 'package:local_basket/data/datasource/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_dataSource.dart';
import 'package:local_basket/data/model/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_model.dart';
import 'package:local_basket/domain/repository/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_repository.dart';

class GuestMenuByRestaurantIdRepositoryImpl
    implements GuestMenuByRestaurantIdRepository {
  final GuestMenuByRestaurantIdRemoteDataSource remoteDataSource;

  GuestMenuByRestaurantIdRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GuestMenuByRestaurantIdModel> guestMenuByRestaurantId(
      Map<String, dynamic> params) {
    return remoteDataSource.guestMenuByRestaurantId(params);
  }
}
