import 'package:local_basket/data/model/address/getAddress/getAddress_model.dart';

abstract class GetAddressRepository {
  Future<GetAddressModel> getAddress();
}
