import 'package:flutter/material.dart';

class BookingLocationWidget extends StatelessWidget {
  const BookingLocationWidget({super.key, required this.txt, required this.voidCallback});

  final String? txt;
  final VoidCallback voidCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: InkWell(
          onTap: voidCallback,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: Text(
                  txt.toString(),
                  // 'Pickup Location',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black, fontFamily: 'Roboto'),
                ),
              ),
              Icon(Icons.map_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
