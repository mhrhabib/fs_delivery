import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../../Controllers/dashboard_controller.dart';
import '../../fsSpotApp/controllers/fs_spot_dashboard_controller.dart';
import '../Widgets/constant.dart';

class BarcodeParcel extends StatefulWidget {
  const BarcodeParcel({super.key});

  @override
  State<BarcodeParcel> createState() => _BarcodeParcelState();
}

class _BarcodeParcelState extends State<BarcodeParcel> {
  String result = '';
  DashboardController dashboardController = Get.put(DashboardController());
  TextEditingController barcodeController = TextEditingController();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'Barcode Scanner'.tr,
          style: kTextStyle.copyWith(color: kBgColor, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        titleSpacing: 25,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: kBgColor),
      ),
      body: GetBuilder<DashboardController>(
        init: DashboardController(),
        builder: (barcodeParcel) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isChecked == false
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                      ),
                      onPressed: () async {
                        String? res = await SimpleBarcodeScanner.scanBarcode(
                          context,
                          barcodeAppBar: const BarcodeAppBar(
                            appBarTitle: 'Test',
                            centerTitle: false,
                            enableBackButton: true,
                            backButtonIcon: Icon(Icons.arrow_back_ios),
                          ),
                          isShowFlashIcon: true,
                          delayMillis: 2000,
                          cameraFace: CameraFace.back,
                        );
                        setState(() {
                          result = res as String;
                          barcodeParcel.getBarcodeParcel(context, result);
                        });
                      },
                      child: Obx(
                        () => barcodeParcel.dashboardLoader.value
                            ? Center(
                                child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                            : const Text(
                                'Open Barcode Scanner',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    )
                  : SizedBox.shrink(),
              isChecked == false ? Text('Parcel: $result') : SizedBox.shrink(),
              isChecked == false ? Text('or') : SizedBox.shrink(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Switch(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value;
                      });
                    },
                  ),
                  isChecked ? Text('Use barcode scanner instead!') : Text('Enter tracking id manually!'),
                ],
              ),
              isChecked
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 55,
                        child: TextField(
                          controller: barcodeController,
                          decoration: InputDecoration(
                            hintText: "Enter tracking id",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              isChecked
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, minimumSize: Size(220, 45)),
                        onPressed: () async {
                          if (barcodeController.text.isEmpty) {
                            Get.rawSnackbar(title: "Empty", message: "Enter tracking id");
                          }

                          if (barcodeController.text.isNotEmpty) {
                            await barcodeParcel.getBarcodeParcel(context, barcodeController.text);
                            barcodeController.clear();
                          }
                        },
                        child: Obx(
                          () => barcodeParcel.dashboardLoader.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
                              : Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class SpotBarcodeParcel extends StatefulWidget {
  const SpotBarcodeParcel({super.key});

  @override
  State<SpotBarcodeParcel> createState() => _SpotBarcodeParcelState();
}

class _SpotBarcodeParcelState extends State<SpotBarcodeParcel> {
  String result = '';
  FsSpotDashboardController dashboardController = Get.put(FsSpotDashboardController());
  TextEditingController barcodeController = TextEditingController();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'Barcode Scanner'.tr,
          style: kTextStyle.copyWith(color: kBgColor, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        titleSpacing: 25,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: kBgColor),
      ),
      body: GetBuilder<FsSpotDashboardController>(
        init: FsSpotDashboardController(),
        builder: (barcodeParcel) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isChecked == false
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                      ),
                      onPressed: () async {
                        String? res = await SimpleBarcodeScanner.scanBarcode(
                          context,
                          barcodeAppBar: const BarcodeAppBar(
                            appBarTitle: 'Test',
                            centerTitle: false,
                            enableBackButton: true,
                            backButtonIcon: Icon(Icons.arrow_back_ios),
                          ),
                          isShowFlashIcon: true,
                          delayMillis: 2000,
                          cameraFace: CameraFace.back,
                        );
                        setState(() {
                          result = res as String;
                          barcodeParcel.getBarcodeParcel(context, result);
                        });
                      },
                      child: Obx(
                        () => barcodeParcel.dashboardLoader.value
                            ? Center(
                                child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                            : const Text(
                                'Open Barcode Scanner',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    )
                  : SizedBox.shrink(),
              isChecked == false ? Text('Parcel: $result') : SizedBox.shrink(),
              isChecked == false ? Text('or') : SizedBox.shrink(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Switch(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value;
                      });
                    },
                  ),
                  isChecked ? Text('Use barcode scanner instead!') : Text('Enter tracking id manually!'),
                ],
              ),
              isChecked
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 55,
                        child: TextField(
                          controller: barcodeController,
                          decoration: InputDecoration(
                            hintText: "Enter tracking id",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              isChecked
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, minimumSize: Size(220, 45)),
                        onPressed: () async {
                          if (barcodeController.text.isEmpty) {
                            Get.rawSnackbar(title: "Empty", message: "Enter tracking id");
                          }

                          if (barcodeController.text.isNotEmpty) {
                            await barcodeParcel.getBarcodeParcel(context, barcodeController.text);
                            barcodeController.clear();
                          }
                        },
                        child: Obx(
                          () => barcodeParcel.dashboardLoader.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
                              : Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
