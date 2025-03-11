import 'package:fs_delivery/deliverymanApp/repository/payment_repository.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;
  void makePayment({
    String? phone,
    String? amount,
    String? paymentId,
    String? paymentMethod,
    String? paymentType,
  }) async {
    isLoading.value = true;
    try {
      var response = PaymentRepository.makePayment(phone: phone, amount: amount, paymentId: paymentId, paymentMethod: paymentMethod, paymentType: paymentType);
      print(response);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
