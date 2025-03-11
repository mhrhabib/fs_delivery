import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ParcelPaymentLogShimmer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ParcelPaymentLogShimmerState();
  }
}

class _ParcelPaymentLogShimmerState extends State<ParcelPaymentLogShimmer> {
  var mainHeight, mainWidth;

  @override
  Widget build(BuildContext context) {
    mainHeight = MediaQuery.of(context).size.height;
    mainWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: ListView.separated(
        itemCount: 15,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
              highlightColor: Colors.grey[400]!,
              baseColor: Colors.grey[300]!,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.088,
                      child: Text(
                        'parcel date',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.188,
                      child: Text('parcel delivery',
                          style: const TextStyle(
                            fontSize: 14,
                          )),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.088,
                      child: Text(
                        '0.00',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        },
        separatorBuilder: (context, index) {
          return Divider(height: 1, color: Colors.grey.withOpacity(.5));
        },
      ),
    );
  }
}
