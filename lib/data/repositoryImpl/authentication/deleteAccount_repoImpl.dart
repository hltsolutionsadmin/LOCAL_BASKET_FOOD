import 'package:local_basket/data/datasource/authentication/deleteAccount_dataSource.dart';
import 'package:local_basket/data/model/authentication/deleteAccount_model.dart';
import 'package:local_basket/domain/repository/authentication/deleteAccount_repository.dart';

class DeleteAccountRepositoryImpl implements DeleteAccountRepository {
  final DeleteAccountRemoteDataSource remoteDataSource;

  DeleteAccountRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DeleteAccountModel> deleteAccount() async {
    return await remoteDataSource.deleteAccount();
  }
}
