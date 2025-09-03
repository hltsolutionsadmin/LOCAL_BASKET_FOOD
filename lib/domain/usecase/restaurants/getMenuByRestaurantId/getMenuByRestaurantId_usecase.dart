import 'package:local_basket/data/model/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_model.dart';
import 'package:local_basket/domain/repository/restaurants/getMenuByRestaurantId/getMenuByRestaurantId_repository.dart';

class GetMenuByRestaurantIdUseCase {
  final GetMenuByRestaurantIdRepository repository;

  GetMenuByRestaurantIdUseCase({required this.repository});

  Future<GetMenuByRestaurantIdModel> call(Map<String, dynamic> params) {
    return repository.getMenuByRestaurantId(params);
  }
}
