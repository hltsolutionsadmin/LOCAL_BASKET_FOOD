import 'package:dio/dio.dart';
import 'package:local_basket/core/constants/api_constants.dart';
import 'package:local_basket/data/model/restaurants/guestMenuByRestaurantId/guestMenuByRestaurantId_model.dart';

abstract class GuestMenuByRestaurantIdRemoteDataSource {
  Future<GuestMenuByRestaurantIdModel> guestMenuByRestaurantId(
      Map<String, dynamic> params);
}

class GuestMenuByRestaurantIdRemoteDataSourceImpl
    implements GuestMenuByRestaurantIdRemoteDataSource {
  final Dio client;

  GuestMenuByRestaurantIdRemoteDataSourceImpl({required this.client});

  @override
  Future<GuestMenuByRestaurantIdModel> guestMenuByRestaurantId(
      Map<String, dynamic> params) async {
    try {
      final int restaurantId = params['restaurantId'];
      final String url = '$baseUrl${guestMenuByRestaurantIdUrl(restaurantId)}';

      final response = await client.get(url);

      if (response.statusCode == 200) {
        print('Response from GuestMenuByRestaurantId: ${response.data}');
        return GuestMenuByRestaurantIdModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to load guest menu: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load guest menu: ${e.toString()}');
    }
  }
}
