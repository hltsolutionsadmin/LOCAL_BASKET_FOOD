import 'package:local_basket/data/datasource/address/saveAddress/saveAddress_dataSource.dart';
import 'package:local_basket/data/model/address/saveAddress/saveAddress_model.dart';
import 'package:local_basket/domain/repository/address/saveAddress/saveAddress_repository.dart';

class SaveAddressRepositoryImpl implements SaveAddressRepository {
  final SaveAddressRemoteDataSource remoteDataSource;

  SaveAddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SaveAddressModel> saveAddress(Map<String, dynamic> payload) {
    return remoteDataSource.saveAddress(payload);
  }
}
