import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../Screen/Widgets/constant.dart';
import '../../services/api_list.dart';
import '../utils/stripe_payment_method.dart';
import 'controllers/payment_controller.dart';

class PaymentScreen extends StatefulWidget {
  final String paymentID;
  final String amount;

  const PaymentScreen({required this.paymentID, required this.amount, super.key});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod; // To store the selected payment method

  final TextEditingController phoneController = TextEditingController();
  final PaymentController paymentController = Get.put(PaymentController());

  // Variables for card details
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> cardFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(widget.paymentID);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Payment Screen'),
      ),
      body: Obx(
        () => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Payment Method',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    // Container for Radio Buttons
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Light grey background
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      child: Column(
                        children: [
                          // MPesa Express Radio Button
                          RadioListTile<String>(
                            title: Text(
                              'MPesa Express',
                              style: TextStyle(fontSize: 16),
                            ),
                            value: 'MPesa Express',
                            groupValue: _selectedPaymentMethod,
                            onChanged: (value) {
                              setState(() {
                                _selectedPaymentMethod = value;
                              });
                            },
                            activeColor: Colors.blue, // Selected color
                          ),
                          Divider(height: 1, color: Colors.grey[400]), // Divider between options
                          // MPesa C2B Radio Button
                          RadioListTile<String>(
                            title: Text(
                              'MPesa C2B',
                              style: TextStyle(fontSize: 16),
                            ),
                            value: 'MPesa C2B',
                            groupValue: _selectedPaymentMethod,
                            onChanged: (value) {
                              setState(() {
                                _selectedPaymentMethod = value;
                              });
                            },
                            activeColor: Colors.blue, // Selected color
                          ),
                          Divider(height: 1, color: Colors.grey[400]), // Divider between options
                          // Card Radio Button
                          RadioListTile<String>(
                            title: Text(
                              'Card',
                              style: TextStyle(fontSize: 16),
                            ),
                            value: 'Card',
                            groupValue: _selectedPaymentMethod,
                            onChanged: (value) {
                              setState(() {
                                _selectedPaymentMethod = value;
                              });
                            },
                            activeColor: Colors.blue, // Selected color
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    if (_selectedPaymentMethod == 'MPesa Express' || _selectedPaymentMethod == 'MPesa C2B')
                      AppTextField(
                        showCursor: true,
                        cursorColor: kTitleColor,
                        controller: phoneController,
                        validator: (value) {
                          if (phoneController.text.isEmpty) {
                            return "this_field_can_t_be_empty".tr;
                          }
                          return null;
                        },
                        textFieldType: TextFieldType.PHONE,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'mobile'.tr,
                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                          hintText: '017XXXXXXXX',
                          hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                      ),
                    // if (_selectedPaymentMethod == 'Card')
                    // Column(
                    //   children: [
                    //     CreditCardWidget(
                    //       cardNumber: cardNumber,
                    //       expiryDate: expiryDate,
                    //       cardHolderName: cardHolderName,
                    //       cvvCode: cvvCode,
                    //       showBackView: isCvvFocused,
                    //       onCreditCardWidgetChange: (value) {},
                    //     ),
                    //     CreditCardForm(
                    //       formKey: cardFormKey,
                    //       cardNumber: cardNumber,
                    //       expiryDate: expiryDate,
                    //       cardHolderName: cardHolderName,
                    //       cvvCode: cvvCode,
                    //       onCreditCardModelChange: (creditCardModel) {
                    //         setState(() {
                    //           cardNumber = creditCardModel.cardNumber;
                    //           expiryDate = creditCardModel.expiryDate;
                    //           cardHolderName = creditCardModel.cardHolderName;
                    //           cvvCode = creditCardModel.cvvCode;
                    //           isCvvFocused = creditCardModel.isCvvFocused;
                    //         });
                    //       },
                    //     ),
                    // ],
                    // ),
                    Gap(12),
                    // Payment Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_selectedPaymentMethod != null) {
                            // Handle payment based on the selected method
                            _handlePayment(_selectedPaymentMethod!);
                          } else {
                            // Show error if no payment method is selected
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please select a payment method'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          backgroundColor: Colors.blue, // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Rounded corners
                          ),
                        ),
                        child: Text(
                          'Proceed to Payment',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    Gap(50),
                  ],
                ),
              ),
            ),
            if (paymentController.isLoading.value)
              Positioned.fill(
                child: Container(
                  height: SizeConfig.screenHeight,
                  color: Colors.black.withValues(alpha: 0.5), // Semi-transparent background
                  child: Center(
                    child: Loader(), // Loader
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handlePayment(String paymentMethod) async {
    if (paymentMethod == 'MPesa Express') {
      print('Express');
      await paymentController.makePayment(
        phone: phoneController.value.text,
        paymentId: widget.paymentID,
        paymentMethod: 'mpesa',
        paymentType: 'mpesa_express',
        amount: widget.amount,
        url: '${APIList.server}payments/process',
      );
    } else if (paymentMethod == 'MPesa C2B') {
      await paymentController.makePayment(
        phone: phoneController.value.text,
        paymentId: widget.paymentID,
        paymentMethod: 'c2b',
        paymentType: 'c2b',
        amount: widget.amount,
        url: '${APIList.server}payments/process',
      );
    } else if (paymentMethod == 'Card') {
      stripePaymentInitialize(
        context: context,
        amount: double.parse(widget.amount).round().toString(),
        currency: 'USD',
        paymentid: widget.paymentID,
      );
    }
  }
}
