import 'package:local_basket/data/model/cart/createCart/createCart_model.dart';
import 'package:local_basket/domain/repository/cart/createCart/createCart_repository.dart';

class CreateCartUseCase {
  final CreateCartRepository repository;

  CreateCartUseCase({required this.repository});

  Future<CreateCartModel> call() async {
    return await repository.createCart();
  }
}
