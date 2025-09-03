import 'package:local_basket/data/datasource/address/getAddress/getAddress_dataSource.dart';
import 'package:local_basket/data/model/address/getAddress/getAddress_model.dart';
import 'package:local_basket/domain/repository/address/getAddress/getAddress_repository.dart';

class GetAddressRepositoryImpl implements GetAddressRepository {
  final GetAddressRemoteDataSource remoteDataSource;

  GetAddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GetAddressModel> getAddress() async {
    return await remoteDataSource.getAddress();
  }
}
