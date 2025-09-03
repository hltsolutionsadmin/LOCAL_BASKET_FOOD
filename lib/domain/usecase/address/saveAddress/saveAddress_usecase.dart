import 'package:local_basket/data/model/address/saveAddress/saveAddress_model.dart';
import 'package:local_basket/domain/repository/address/saveAddress/saveAddress_repository.dart';

class SaveAddressUseCase {
  final SaveAddressRepository repository;

  SaveAddressUseCase({required this.repository});

  Future<SaveAddressModel> call(Map<String, dynamic> payload) {
    return repository.saveAddress(payload);
  }
}
