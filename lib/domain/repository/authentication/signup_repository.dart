
import 'package:local_basket/data/model/authentication/signup_model.dart';

abstract class SignUpRepository {
  Future<SignUpModel> getOtp(String mobileNumber);
}
