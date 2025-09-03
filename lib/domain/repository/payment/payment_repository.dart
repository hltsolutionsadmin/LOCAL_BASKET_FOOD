import 'package:local_basket/data/model/payment/payment_model.dart';
import 'package:local_basket/data/model/payments/payment_refund_model.dart';
import 'package:local_basket/data/model/payments/refund_status_model.dart';

abstract class PaymentRepository {
  Future<PaymentModel> makePayment(Map<String, dynamic> payload);
  Future<PaymentStausModel> PaymentTracking(String paymentId);
  Future<PaymentRefundModel> PaymentRefund(String paymentId);
}
