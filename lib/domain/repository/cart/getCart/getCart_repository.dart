import 'package:local_basket/data/model/cart/getCart/getCart_model.dart';

abstract class GetCartRepository {
  Future<GetCartModel> getCart();
}
