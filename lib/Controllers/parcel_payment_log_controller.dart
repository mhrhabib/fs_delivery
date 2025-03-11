import 'dart:convert';
import '../Models/parcel_payment_log_model.dart';
import '../services/api_list.dart';
import '/services/server.dart';
import '/services/user-service.dart';
import 'package:get/get.dart';

class ParcelPaymentLogController extends GetxController {
  UserService userService = UserService();
  Server server = Server();
  List<ParcelPaymentLogs> parcelPaymentLogList = <ParcelPaymentLogs>[];
  bool loader = true;

  @override
  void onInit() {
    getParcelPaymentLog();
    super.onInit();
  }

  getParcelPaymentLog() {
    parcelPaymentLogList = <ParcelPaymentLogs>[];
    server.getRequest(endPoint: APIList.deliverymanPaymentParcelLogs).then((response) {
      if (response != null && response.statusCode == 200) {
        loader = false;
        final jsonResponse = json.decode(response.body);
        var dashboard = ParcelPaymentLogModel.fromJson(jsonResponse);
        parcelPaymentLogList.addAll(dashboard.data!.parcelPaymentLogs!);
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      } else {
        loader = false;
        Future.delayed(Duration(milliseconds: 10), () {
          update();
        });
      }
    });
  }
}
