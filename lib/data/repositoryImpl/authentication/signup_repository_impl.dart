import 'package:local_basket/data/datasource/authentication/signup_remote_data_source.dart';
import 'package:local_basket/data/model/authentication/signup_model.dart';
import 'package:local_basket/domain/repository/authentication/signup_repository.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  final SignUpRemoteDataSource remoteDataSource;

  SignUpRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SignUpModel> getOtp(String mobileNumber) async {
    final model = await remoteDataSource.fetchOtp(mobileNumber);
    return SignUpModel(
      creationTime: model.creationTime,
      otp: model.otp,
    );
  }
}
