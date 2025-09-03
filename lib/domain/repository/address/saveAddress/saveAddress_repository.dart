import 'package:local_basket/data/model/address/saveAddress/saveAddress_model.dart';

abstract class SaveAddressRepository {
  Future<SaveAddressModel> saveAddress(Map<String, dynamic> payload);
}
