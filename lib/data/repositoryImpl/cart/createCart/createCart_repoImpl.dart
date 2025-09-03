

import 'package:local_basket/data/datasource/cart/createCart/createCart_dataSource.dart';
import 'package:local_basket/data/model/cart/createCart/createCart_model.dart';
import 'package:local_basket/domain/repository/cart/createCart/createCart_repository.dart';

class CreateCartRepositoryImpl implements CreateCartRepository {
  final CreateCartRemoteDataSource remoteDataSource;

  CreateCartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CreateCartModel> createCart() {
    return remoteDataSource.createCart();
  }
}
