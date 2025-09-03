
import 'package:local_basket/data/model/authentication/rolesPost_model.dart';

abstract class RolePostRepository {
  Future<RolePostModel> rolePost(String? role);
}
