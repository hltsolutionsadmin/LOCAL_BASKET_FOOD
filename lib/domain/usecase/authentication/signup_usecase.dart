import 'package:local_basket/data/model/authentication/signup_model.dart';
import 'package:local_basket/domain/repository/authentication/signup_repository.dart';

class SignUpValidationUseCase {
  final SignUpRepository repository;

  SignUpValidationUseCase({required this.repository});

  Future<SignUpModel> call(String mobileNumber) async {
    return await repository.getOtp(mobileNumber);
  }
}
