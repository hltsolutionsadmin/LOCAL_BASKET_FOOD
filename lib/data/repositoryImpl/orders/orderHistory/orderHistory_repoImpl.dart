import 'package:local_basket/data/datasource/orders/orderHistory/orderHistory_dataSource.dart';
import 'package:local_basket/data/model/orders/orderHistory/orderHistory_model.dart';
import 'package:local_basket/domain/repository/orders/orderHistory/orderHistory_repository.dart';

class OrderHistoryRepositoryImpl implements OrderHistoryRepository {
  final OrderHistoryRemoteDataSource remoteDataSource;

  OrderHistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OrderHistoryModel> orderHistory(int page, int size, String searchQuery) {
    return remoteDataSource.orderHistory(page, size, searchQuery);
  }
}