import 'package:dio/dio.dart' as dio;
import 'package:fs_delivery/Screen/Authentication/signUp/controller/sign_up_controller.dart';
import 'package:get/get.dart';
import '../../../../services/api_list.dart';
import '../../../../services/base_client.dart';

class SignUpRepo {
  static Future signUpApiCall({
    String? userType,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? password,
    int? hubId,
    double? lat,
    double? long,
    dynamic image,
    dynamic drivingLicense,
  }) async {
    dio.FormData data = dio.FormData.fromMap({
      'user_type': userType,
      'name': name,
      'email': email,
      'mobile': phone,
      'address': address,
      'password': password,
      'hub_id': hubId,
      'lat': lat,
      'long': long,
    });
    image != null ? data.files.add(MapEntry("image", await dio.MultipartFile.fromFile(image))) : null;
    drivingLicense != null ? data.files.add(MapEntry("driving_license", await dio.MultipartFile.fromFile(drivingLicense))) : null;
    print(data.files);
    print(data.fields);
    try {
      dio.Response response = await BaseClient.post(url: APIList.register, payload: data);
      // dio.Response response = await dio.Dio().post(APIList.register!,
      //     data: data,
      //     options: Options(
      //         followRedirects: false,
      //         validateStatus: (status) {
      //           return status! < 500;
      //         },
      //         headers: {
      //           //'Content-Type': 'multipart/form-data',
      //           "Accept": "application/json",
      //           'Content-type': 'application/json',
      //           'X-Requested-With': 'XMLHttpRequest',
      //           'apiKey': '123456rx-ecourier123456',
      //           'Authorization': 'Bearer ${await storage.read('token')}',
      //         }));
      print(response.statusCode);

      if (response.statusCode == 200) {
        print(" signup response ${response.data}");
        return response.data;
      }
      throw "${response.statusCode}: ${response.statusMessage}";
    } catch (e) {
      Get.find<SignUpController>().isLoading.value = false;
      rethrow;
    }
  }

  static Future signUpVerifyApiCall({String? otp, String? mobile}) async {
    var data = {
      'otp': otp,
      'mobile': mobile,
    };
    print(data);
    try {
      dio.Response response = await BaseClient.post(url: APIList.verifyOtp, payload: data);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("failed");
      }
    } catch (e) {
      print(e);
    } finally {
      Get.find<SignUpController>().isLoading.value = false;
    }
  }
}
