import 'package:flutter/material.dart';
import 'package:fs_delivery/Screen/Authentication/signUp/controller/sign_up_controller.dart';
import 'package:map_location_picker/map_location_picker.dart';

class MapScreenOne extends StatefulWidget {
  const MapScreenOne({super.key, required this.controller});

  final SignUpController controller;

  @override
  State<MapScreenOne> createState() => _MapScreenOneState();
}

class _MapScreenOneState extends State<MapScreenOne> {
  String address = "null";
  String autocompletePlace = "null";
  Prediction? initialValue;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('location picker'),
        // ),
        body: MapLocationPicker(
          apiKey: 'AIzaSyD37xTUmtnOlDT23hpE_XoFYByzshd6rK8',
          popOnNextButtonTaped: true,
          currentLatLng: const LatLng(29.146727, 76.464895),
          onNext: (GeocodingResult? result) {
            if (result != null) {
              setState(() {
                address = result.formattedAddress ?? "";
                widget.controller.lat!.value = result.geometry.location.lat;
                widget.controller.long!.value = result.geometry.location.lng;
                widget.controller.addressController.value = address;
              });
              //print(parcelController.pickupLat.value);
            }
          },
          onSuggestionSelected: (PlacesDetailsResponse? result) {
            if (result != null) {
              setState(() {
                autocompletePlace = result.result.formattedAddress ?? "";
                // parcelController.pickupAddress.value = autocompletePlace;
              });
            }
          },
        ),
        // body: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     PlacesAutocomplete(
        //       searchController: _controller,
        //       apiKey: 'AIzaSyBLwDuKGRRfRXYXcoNBlni85nLyErNZkQM',
        //       mounted: mounted,
        //       hideBackButton: true,
        //       onGetDetailsByPlaceId: (PlacesDetailsResponse? result) {
        //         if (result != null) {
        //           setState(() {
        //             autocompletePlace = result.result.formattedAddress ?? "";
        //           });
        //         }
        //       },
        //     ),
        //     // TextButton(
        //     //   onPressed: () => Clipboard.setData(
        //     //     const ClipboardData(text: "https://www.mohesu.com"),
        //     //   ).then(
        //     //     (value) => ScaffoldMessenger.of(context).showSnackBar(
        //     //       const SnackBar(
        //     //         content: Text("Copied to Clipboard"),
        //     //       ),
        //     //     ),
        //     //   ),
        //     //   child: const Text("https://www.mohesu.com"),
        //     // ),
        //     const Spacer(),

        //   ],
        // ),
      ),
    );
  }
}
