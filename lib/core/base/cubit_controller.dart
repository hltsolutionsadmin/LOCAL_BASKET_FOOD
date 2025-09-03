import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_basket/core/network/dio_client.dart';
import 'package:local_basket/core/utils/enums/enums.dart';

class BaseCubit extends Cubit<ApiStatus> {
  late DioClient dioClient;

  BaseCubit() : super(ApiStatus.SUCCESS) {
    initializeDioClient();
  }

  Future<void> initializeDioClient() async {
    final secureStorage = FlutterSecureStorage();
    dioClient = DioClient(Dio(), secureStorage: secureStorage);
  }
}
