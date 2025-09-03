import 'package:local_basket/data/model/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_model.dart';

abstract class GuestMenuByRestaurantIdRepository {
  Future<GuestMenuByRestaurantIdModel> guestMenuByRestaurantId(
      Map<String, dynamic> params);
}
