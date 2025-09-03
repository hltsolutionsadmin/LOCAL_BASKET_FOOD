import 'package:local_basket/data/model/restaurants/getRestaurantsByProductName/getRestaurantsByProductName_model.dart';

abstract class GetRestaurantsByProductNameRepository {
  Future<GetRestaurantsByProductNameModel> getRestaurantsByProductName(Map<String, dynamic> params);
}
