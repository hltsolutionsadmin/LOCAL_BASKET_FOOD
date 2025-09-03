import 'package:local_basket/data/model/authentication/update_current_customer_model.dart';

abstract class UpdateCurrentCustomerRepository {
  Future<UpdateCurrentCustomerModel> updateCurrentCustomer(Map<String, dynamic> payload);
}

