import 'package:local_basket/data/model/restaurants/guestNearbyRestaurants/guestNearbyRestaurants_model.dart';
import 'package:local_basket/domain/repository/restaurants/guestNearbyRestaurants/guestNearbyRestaurants_repository.dart';

class GuestNearByRestaurantsUseCase {
  final GuestNearByRestaurantsRepository repository;

  GuestNearByRestaurantsUseCase({required this.repository});

  Future<GuestNearByRestaurantsModel> call(Map<String, dynamic> params) {
    return repository.guestNearByRestaurants(params);
  }
}
