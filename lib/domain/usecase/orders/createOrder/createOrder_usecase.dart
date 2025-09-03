import 'package:local_basket/data/model/orders/createOrder/createOrder_model.dart';
import 'package:local_basket/domain/repository/orders/createOrder/createOrder_repository.dart';

class CreateOrderUseCase {
  final CreateOrderRepository repository;

  CreateOrderUseCase({required this.repository});

  Future<CreateOrderModel> call(dynamic body) async {
    return await repository.createOrder(body);
  }
}
