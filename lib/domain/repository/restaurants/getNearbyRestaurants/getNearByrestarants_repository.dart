import 'package:local_basket/data/model/restaurants/getNearbyRestaurants/getNearByrestarants_model.dart';

abstract class GetNearByRestaurantsRepository {
  Future<GetNearByRestaurantsModel> getNearByRestaurants(Map<String, dynamic> params);
}
