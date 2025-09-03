import 'package:local_basket/data/model/restaurants/guestNearbyRestaurants/guestNearbyRestaurants_model.dart';

abstract class GuestNearByRestaurantsRepository {
  Future<GuestNearByRestaurantsModel> guestNearByRestaurants(Map<String, dynamic> params);
}
