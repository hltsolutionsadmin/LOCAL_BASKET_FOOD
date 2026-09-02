import 'package:dio/dio.dart';
import 'package:local_basket/core/constants/global_exception_handler.dart';
import 'package:local_basket/core/constants/api_constants.dart';
import 'package:local_basket/data/model/address/saveAddress/saveAddress_model.dart';

abstract class SaveAddressRemoteDataSource {
  Future<SaveAddressModel> saveAddress(Map<String, dynamic> payload);
}

class SaveAddressRemoteDataSourceImpl implements SaveAddressRemoteDataSource {
  final Dio client;

  SaveAddressRemoteDataSourceImpl({required this.client});

  @override
  Future<SaveAddressModel> saveAddress(Map<String, dynamic> payload) async {
    try {
      final addressId = payload["id"]?.toString();
      final isUpdate = addressId != null && addressId.isNotEmpty;

      final Response response;
      if (isUpdate) {
        final updatePayload = Map<String, dynamic>.from(payload)
          ..remove("id");
        response = await client.put(
          '$addressUpdateBaseUrl${updateAddressUrl(addressId)}',
          data: updatePayload,
        );
      } else {
        response = await client.post(
          '$baseUrl$saveAddressUrl',
          data: payload,
        );
      }
      final String requestUrl = isUpdate
          ? '$addressUpdateBaseUrl${updateAddressUrl(addressId)}'
          : '$baseUrl$saveAddressUrl';
      print('PUT/POST $requestUrl');
      print('SaveAddress Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SaveAddressModel.fromJson(response.data);
      } else {
        throw UnknownBackendException("Unable to complete this request. Please try again after some time.");
      }
    } on DioException catch (e) {
      print('SAVE ADDRESS STATUS: ${e.response?.statusCode}');
      print('SAVE ADDRESS RESPONSE: ${e.response?.data}');
      print('SAVE ADDRESS PAYLOAD: $payload');

      throw handleDioError(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownBackendException("Unable to complete this request. Please try again after some time.");
    }
  }
}
