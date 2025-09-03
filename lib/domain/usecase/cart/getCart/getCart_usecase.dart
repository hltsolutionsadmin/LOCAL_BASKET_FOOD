import 'package:local_basket/data/model/cart/getCart/getCart_model.dart';
import 'package:local_basket/domain/repository/cart/getCart/getCart_repository.dart';

class GetCartUseCase {
  final GetCartRepository repository;

  GetCartUseCase({required this.repository});

  Future<GetCartModel> execute() {
    return repository.getCart();
  }
}
