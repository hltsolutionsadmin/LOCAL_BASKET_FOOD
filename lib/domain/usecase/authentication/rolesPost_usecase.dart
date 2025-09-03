import 'package:local_basket/data/model/authentication/rolesPost_model.dart';
import 'package:local_basket/domain/repository/authentication/rolesPost_repository.dart';

class RolePostUsecase {
  final RolePostRepository repository;

  RolePostUsecase(this.repository);

  Future<RolePostModel> call(String? role) async {
    return await repository.rolePost(role);
  }
}
