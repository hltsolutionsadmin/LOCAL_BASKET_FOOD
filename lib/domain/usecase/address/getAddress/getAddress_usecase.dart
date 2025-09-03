import 'package:local_basket/data/model/address/getAddress/getAddress_model.dart';
import 'package:local_basket/domain/repository/address/getAddress/getAddress_repository.dart';

class GetAddressUseCase {
  final GetAddressRepository repository;

  GetAddressUseCase({required this.repository});

  Future<GetAddressModel> call() async {
    return await repository.getAddress();
  }
}
