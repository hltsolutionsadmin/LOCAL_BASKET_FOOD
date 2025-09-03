import 'package:local_basket/data/model/cart/createCart/createCart_model.dart';

abstract class CreateCartState {}

class CreateCartInitial extends CreateCartState {}

class CreateCartLoading extends CreateCartState {}

class CreateCartLoaded extends CreateCartState {
  final CreateCartModel cart;

  CreateCartLoaded(this.cart);
}

class CreateCartError extends CreateCartState {
  final String message;

  CreateCartError(this.message);
}
