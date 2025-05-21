class APIList {
  static String? server = "https://fspickupspots.com/api/v10/";
  static String? apiUrl = "fspickupspots.com";
  static String? apiCheckKey = "123456rx-ecourier123456";
  static String? apiEndPoint = "/api/v10/";

  // Common Endpoints
  static String? login = "${server!}login";
  static String? register = "${server!}register";
  static String? logout = "${server!}sign-out";
  static String? hub = "${server!}hub";
  static String? refreshToken = "${server!}refresh";
  static String? otpLogin = "${server!}otp-login";
  static String? device = "${server!}device";
  static String? fcmSubscribe = "${server!}fcm-subscribe";
  static String? fcmUnSubscribe = "${server!}fcm-unsubscribe";
  static String? generalSettings = "${server!}general-settings";
  static String? passwordUpdate = "${server!}update-password";
  static String? otpCheck = "${server!}otp/check";
  static String? verifyOtp = "${server!}otp-verification";
  static String? sentOtpForReset = "${server!}password/email";
  static String? resendOtp = "${server!}resend-otp";
  static String? passwordReset = "${server!}password/reset";

  // Deliveryman Endpoints

  static String? deliverymanOtpResend = "${server!}resend-otp";

  static String? deliverymanProfile = "${server!}deliveryman/profile";
  static String? deliverymanProfileUpdate = "${server!}profile/update";
  static String? deliverymanDashboard = "${server!}deliveryman/dashboard";
  static String? deliverymanPaymentLogs = "${server!}deliveryman/payment-logs";
  static String? deliverymanPaymentParcelLogs = "${server!}deliveryman/parcel-payment-logs";
  static String? deliverymanChangeStatus = "${server!}deliveryman/parcel-status-update";
  static String? deliverymanSignUpOtpVerify = "${server!}deliveryman/otp-verification";
  // static String? deliverymanSentOtpForReset = "${server!}deliveryman/password/email";
  // static String? deliverymanPasswordReset = "${server!}deliveryman/password/reset";
  // static String? deliverymanResendOtp = "${server!}deliveryman/resend-otp";
  static String? deliverymanBarcodeParcel = "${server!}deliveryman/parcel/find/";
  static String? parcelMapUrl = "${server}deliveryMan/parcel/map/";

  // Spot Manager Endpoints

  static String? spotManagerOtpResend = "${server!}spot_manager/resend-otp";
  static String? spotManagerVerifyOtp = "${server!}spot_manager/otp-verification";
  static String? spotManagerProfile = "${server!}spot_manager/profile";
  static String? spotManagerProfileUpdate = "${server!}spot_manager/profile/update";
  static String? spotManagerChangeStatus = "${server!}spot_manager/parcel-status-update";
  static String? spotManagerDashboard = "${server!}spot_manager/dashboard";
  static String? spotManagerReturnUrl = "${server!}spot_manager/parcel/return";

  static String? spotManagerBarcodeParcel = "${server!}spot_manager/parcel/find/";

  // Get the correct endpoint based on userType

  static String? getProfileUrl(String userType) {
    return userType == 'deliveryman' ? deliverymanProfile : spotManagerProfile;
  }

  static String? getDashboardUrl(String userType) {
    return userType == 'deliveryman' ? deliverymanDashboard : spotManagerDashboard;
  }

  static String? getProfileUpdateUrl(String userType) {
    return userType == 'deliveryman' ? deliverymanProfileUpdate : spotManagerProfileUpdate;
  }

  // Add more methods for other endpoints as needed
}
