import 'package:local_basket/data/datasource/orders/createOrder/createOrder_dataSource.dart';
import 'package:local_basket/data/model/orders/createOrder/createOrder_model.dart';
import 'package:local_basket/domain/repository/orders/createOrder/createOrder_repository.dart';

class CreateOrderRepositoryImpl implements CreateOrderRepository {
  final CreateOrderRemoteDataSource remoteDataSource;

  CreateOrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CreateOrderModel> createOrder(dynamic body) {
    return remoteDataSource.createOrder(body);
  }
}