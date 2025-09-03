import 'package:local_basket/data/model/orders/orderHistory/orderHistory_model.dart';

abstract class OrderHistoryRepository {
  Future<OrderHistoryModel> orderHistory(int page, int size, String searchQuery);
}