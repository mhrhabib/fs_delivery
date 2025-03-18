import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../services/base_client.dart';
import '../controllers/payment_controller.dart';

class PaymentRepository {
  static Future makePayment({
    String? phone,
    String? amount,
    String? paymentId,
    String? paymentMethod,
    String? paymentType,
    String? url,
  }) async {
    try {
      var data = {
        'phone': phone,
        'amount': amount,
        'payment_id': paymentId,
        'payment_method': paymentMethod,
        'payment_type': paymentType,
      };

      print(data);

      dio.Response response = await BaseClient.post(url: url, payload: data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        Fluttertoast.showToast(msg: response.data['message']);
        throw "${response.data['message']}";
      }
    } catch (e) {
      rethrow;
    } finally {
      Get.find<PaymentController>().isLoading.value = false;
    }
  }
}
