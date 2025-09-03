
import 'package:local_basket/data/datasource/authentication/update_current_customer_dataSource.dart';
import 'package:local_basket/data/model/authentication/update_current_customer_model.dart';
import 'package:local_basket/domain/repository/authentication/update_current_customer_repository.dart';

class UpdateCurrentCustomerRepositoryImpl implements UpdateCurrentCustomerRepository {
  final UpdateCurrentCustomerRemoteDatasource remoteDatasource;

  UpdateCurrentCustomerRepositoryImpl({required this.remoteDatasource});

  @override
  Future<UpdateCurrentCustomerModel> updateCurrentCustomer(Map<String, dynamic> payload) {
    return remoteDatasource.updateCurrentCustomer(payload: payload);
  }
}
