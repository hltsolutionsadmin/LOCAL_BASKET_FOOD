import 'package:local_basket/data/model/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_model.dart';
import 'package:local_basket/domain/repository/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_repository.dart';

class GuestMenuByRestaurantIdUseCase {
  final GuestMenuByRestaurantIdRepository repository;

  GuestMenuByRestaurantIdUseCase({required this.repository});

  Future<GuestMenuByRestaurantIdModel> call(Map<String, dynamic> params) {
    return repository.guestMenuByRestaurantId(params);
  }
}
