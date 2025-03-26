import 'package:fs_delivery/Screen/Home/dashboard/dashboard_screen.dart';
import 'package:fs_delivery/fsSpotApp/dashboard/fs_spot_dashboard.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../Screen/Widgets/constant.dart';
import '../repository/payment_repository.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;

  makePayment({
    String? phone,
    String? amount,
    String? paymentId,
    String? paymentMethod,
    String? paymentType,
    String? url,
  }) async {
    isLoading.value = true; // Show loader
    try {
      // Simulate API call or payment processing
      var response = await PaymentRepository.makePayment(
        phone: phone,
        amount: amount,
        paymentId: paymentId,
        paymentMethod: paymentMethod,
        paymentType: paymentType,
        url: url,
      );
      print(response);

      // Wait for 10 seconds (simulating payment processing)
      // await Future.delayed(Duration(seconds: 10));
      if (response['status'] == 'error') {
        toast(response['message']);
      }

      if (storage.read('userType') == 'deliveryman' ? (response['success'] == 'true') : response['status'] == 'success') {
        toast(response['message']);
        Get.off(() => storage.read('userType') == 'deliveryman' ? DashboardScreen() : FsSpotDashboard());
      }

      // Navigate to ParcelPage after payment is complete
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false; // Hide loader
    }
  }
}
