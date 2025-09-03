import 'package:local_basket/data/model/orders/createOrder/createOrder_model.dart';

abstract class CreateOrderRepository {
  Future<CreateOrderModel> createOrder(dynamic body);
}
