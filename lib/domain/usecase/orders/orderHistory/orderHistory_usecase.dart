import 'package:local_basket/data/model/orders/orderHistory/orderHistory_model.dart';
import 'package:local_basket/domain/repository/orders/orderHistory/orderHistory_repository.dart';

class OrderHistoryUseCase {
  final OrderHistoryRepository repository;

  OrderHistoryUseCase({required this.repository});

  Future<OrderHistoryModel> execute(int page, int size, String searchQuery) {
    return repository.orderHistory(page, size, searchQuery);
  }
}
