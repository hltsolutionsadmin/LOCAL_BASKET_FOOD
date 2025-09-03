import 'package:local_basket/data/model/authentication/deleteAccount_model.dart';

abstract class DeleteAccountRepository {
  Future<DeleteAccountModel> deleteAccount();
}
