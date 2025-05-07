import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../Controllers/dashboard_controller.dart';
import '../../fsSpotApp/controllers/fs_spot_dashboard_controller.dart';
import '../Widgets/constant.dart';

class BarcodeScannerScreen extends StatelessWidget {
  final MobileScannerController cameraController = MobileScannerController();

  BarcodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              Navigator.pop(context, barcode.rawValue);
            }
          }
        },
      ),
    );
  }
}

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
              if (!isChecked)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  onPressed: () async {
                    final res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BarcodeScannerScreen(),
                      ),
                    );

                    if (res != null) {
                      setState(() {
                        result = res;
                      });
                      barcodeParcel.getBarcodeParcel(context, result);
                    }
                  },
                  child: Obx(
                    () => barcodeParcel.dashboardLoader.value ? const Center(child: CircularProgressIndicator(color: Colors.white)) : const Text('Open Barcode Scanner', style: TextStyle(color: Colors.white)),
                  ),
                ),
              if (!isChecked) Text('Parcel: $result'),
              if (!isChecked) const Text('or'),
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
                  Text(isChecked ? 'Use barcode scanner instead!' : 'Enter tracking id manually!'),
                ],
              ),
              if (isChecked)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 55,
                    child: TextField(
                      controller: barcodeController,
                      decoration: const InputDecoration(
                        hintText: "Enter tracking id",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              if (isChecked)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, minimumSize: const Size(220, 45)),
                    onPressed: () async {
                      if (barcodeController.text.isEmpty) {
                        Get.rawSnackbar(title: "Empty", message: "Enter tracking id");
                      } else {
                        await barcodeParcel.getBarcodeParcel(context, barcodeController.text);
                        barcodeController.clear();
                      }
                    },
                    child: Obx(
                      () => barcodeParcel.dashboardLoader.value ? const Center(child: CircularProgressIndicator(color: Colors.white)) : const Text("Submit", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
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
              if (!isChecked)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  onPressed: () async {
                    final res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BarcodeScannerScreen(),
                      ),
                    );

                    if (res != null) {
                      setState(() {
                        result = res;
                      });
                      barcodeParcel.getBarcodeParcel(context, result);
                    }
                  },
                  child: Obx(
                    () => barcodeParcel.dashboardLoader.value ? const Center(child: CircularProgressIndicator(color: Colors.white)) : const Text('Open Barcode Scanner', style: TextStyle(color: Colors.white)),
                  ),
                ),
              if (!isChecked) Text('Parcel: $result'),
              if (!isChecked) const Text('or'),
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
                  Text(isChecked ? 'Use barcode scanner instead!' : 'Enter tracking id manually!'),
                ],
              ),
              if (isChecked)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 55,
                    child: TextField(
                      controller: barcodeController,
                      decoration: const InputDecoration(
                        hintText: "Enter tracking id",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              if (isChecked)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, minimumSize: const Size(220, 45)),
                    onPressed: () async {
                      if (barcodeController.text.isEmpty) {
                        Get.rawSnackbar(title: "Empty", message: "Enter tracking id");
                      } else {
                        await barcodeParcel.getBarcodeParcel(context, barcodeController.text);
                        barcodeController.clear();
                      }
                    },
                    child: Obx(
                      () => barcodeParcel.dashboardLoader.value ? const Center(child: CircularProgressIndicator(color: Colors.white)) : const Text("Submit", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
