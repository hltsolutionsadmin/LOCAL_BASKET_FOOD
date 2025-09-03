import 'package:local_basket/data/model/cart/createCart/createCart_model.dart';

abstract class CreateCartRepository {
  Future<CreateCartModel> createCart();
}
