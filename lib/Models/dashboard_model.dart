class DashboardModel {
  bool? success;
  String? message;
  Data? data;

  DashboardModel({this.success, this.message, this.data});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Delivered>? deliverymanAssign;
  List<Delivered>? deliverymanReSchedule;
  List<Delivered>? pickupAssign;
  List<Delivered>? returnToCourier;
  List<Delivered>? delivered;

  Data({this.deliverymanAssign, this.deliverymanReSchedule, this.pickupAssign, this.returnToCourier, this.delivered});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['deliveryman_assign'] != null) {
      deliverymanAssign = <Delivered>[];
      json['deliveryman_assign'].forEach((v) {
        deliverymanAssign!.add(Delivered.fromJson(v));
      });
    }
    if (json['deliveryman_re_schedule'] != null) {
      deliverymanReSchedule = <Delivered>[];
      json['deliveryman_re_schedule'].forEach((v) {
        deliverymanReSchedule!.add(Delivered.fromJson(v));
      });
    }
    if (json['pickup_assign'] != null) {
      pickupAssign = <Delivered>[];
      json['pickup_assign'].forEach((v) {
        pickupAssign!.add(Delivered.fromJson(v));
      });
    }
    if (json['return_to_courier'] != null) {
      returnToCourier = <Delivered>[];
      json['return_to_courier'].forEach((v) {
        returnToCourier!.add(Delivered.fromJson(v));
      });
    }
    if (json['delivered'] != null) {
      delivered = <Delivered>[];
      json['delivered'].forEach((v) {
        delivered!.add(Delivered.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (deliverymanAssign != null) {
      data['deliveryman_assign'] = deliverymanAssign!.map((v) => v.toJson()).toList();
    }
    if (deliverymanReSchedule != null) {
      data['deliveryman_re_schedule'] = deliverymanReSchedule!.map((v) => v.toJson()).toList();
    }
    if (pickupAssign != null) {
      data['pickup_assign'] = pickupAssign!.map((v) => v.toJson()).toList();
    }
    if (returnToCourier != null) {
      data['return_to_courier'] = returnToCourier!.map((v) => v.toJson()).toList();
    }
    if (delivered != null) {
      data['delivered'] = delivered!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliverymanAssign {
  int? id;
  String? trackingId;
  int? merchantId;
  String? merchantName;
  String? merchantUserName;
  String? merchantUserEmail;
  String? merchantMobile;
  String? merchantAddress;
  String? customerName;
  String? customerPhone;
  String? customerAddress;
  String? shipmentType;
  String? invoiceNo;
  String? weight;
  String? totalDeliveryAmount;
  String? codAmount;
  String? vatAmount;
  String? currentPayable;
  String? cashCollection;
  int? deliveryTypeId;
  String? deliveryType;
  int? status;
  String? statusName;
  String? pickupDate;
  String? deliveryDate;
  String? createdAt;
  String? updatedAt;
  String? parcelDate;
  String? parcelTime;
  String? reviewStar;

  DeliverymanAssign(
      {this.id,
      this.trackingId,
      this.merchantId,
      this.merchantName,
      this.merchantUserName,
      this.merchantUserEmail,
      this.merchantMobile,
      this.merchantAddress,
      this.customerName,
      this.customerPhone,
      this.customerAddress,
      this.shipmentType,
      this.invoiceNo,
      this.weight,
      this.totalDeliveryAmount,
      this.codAmount,
      this.vatAmount,
      this.currentPayable,
      this.cashCollection,
      this.deliveryTypeId,
      this.deliveryType,
      this.status,
      this.statusName,
      this.pickupDate,
      this.deliveryDate,
      this.createdAt,
      this.updatedAt,
      this.parcelDate,
      this.parcelTime,
      this.reviewStar});

  DeliverymanAssign.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trackingId = json['tracking_id'];
    merchantId = json['merchant_id'];
    merchantName = json['merchant_name'];
    merchantUserName = json['merchant_user_name'];
    merchantUserEmail = json['merchant_user_email'];
    merchantMobile = json['merchant_mobile'];
    merchantAddress = json['merchant_address'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    customerAddress = json['customer_address'];
    shipmentType = json['shipment_type'];
    invoiceNo = json['invoice_no'];
    weight = json['weight'];
    totalDeliveryAmount = json['total_delivery_amount'];
    codAmount = json['cod_amount'];
    vatAmount = json['vat_amount'];
    currentPayable = json['current_payable'];
    cashCollection = json['cash_collection'];
    deliveryTypeId = json['delivery_type_id'];
    deliveryType = json['deliveryType'];
    status = json['status'];
    statusName = json['statusName'];
    pickupDate = json['pickup_date'];
    deliveryDate = json['delivery_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    parcelDate = json['parcel_date'];
    parcelTime = json['parcel_time'];
    reviewStar = json['review_star'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tracking_id'] = trackingId;
    data['merchant_id'] = merchantId;
    data['merchant_name'] = merchantName;
    data['merchant_user_name'] = merchantUserName;
    data['merchant_user_email'] = merchantUserEmail;
    data['merchant_mobile'] = merchantMobile;
    data['merchant_address'] = merchantAddress;
    data['customer_name'] = customerName;
    data['customer_phone'] = customerPhone;
    data['customer_address'] = customerAddress;
    data['shipment_type'] = shipmentType;
    data['invoice_no'] = invoiceNo;
    data['weight'] = weight;
    data['total_delivery_amount'] = totalDeliveryAmount;
    data['cod_amount'] = codAmount;
    data['vat_amount'] = vatAmount;
    data['current_payable'] = currentPayable;
    data['cash_collection'] = cashCollection;
    data['delivery_type_id'] = deliveryTypeId;
    data['deliveryType'] = deliveryType;
    data['status'] = status;
    data['statusName'] = statusName;
    data['pickup_date'] = pickupDate;
    data['delivery_date'] = deliveryDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['parcel_date'] = parcelDate;
    data['parcel_time'] = parcelTime;
    data['review_star'] = reviewStar;
    return data;
  }
}

class Delivered {
  int? id;
  String? trackingId;
  int? merchantId;
  dynamic merchantName;
  String? merchantUserName;
  String? merchantUserEmail;
  String? merchantMobile;
  String? merchantAddress;
  String? customerName;
  String? customerPhone;
  String? customerAddress;
  String? shipmentType;
  String? invoiceNo;
  String? weight;
  String? totalDeliveryAmount;
  String? codAmount;
  String? vatAmount;
  String? currentPayable;
  String? cashCollection;
  int? deliveryTypeId;
  String? deliveryType;
  int? status;
  String? statusName;
  String? pickupDate;
  String? deliveryDate;
  String? createdAt;
  String? updatedAt;
  String? parcelDate;
  String? parcelTime;
  int? reviewStar;
  String? paymentId;
  int? invoicePaymentStatus;

  Delivered({
    this.id,
    this.trackingId,
    this.merchantId,
    this.merchantName,
    this.merchantUserName,
    this.merchantUserEmail,
    this.merchantMobile,
    this.merchantAddress,
    this.customerName,
    this.customerPhone,
    this.customerAddress,
    this.shipmentType,
    this.invoiceNo,
    this.weight,
    this.totalDeliveryAmount,
    this.codAmount,
    this.vatAmount,
    this.currentPayable,
    this.cashCollection,
    this.deliveryTypeId,
    this.deliveryType,
    this.status,
    this.statusName,
    this.pickupDate,
    this.deliveryDate,
    this.createdAt,
    this.updatedAt,
    this.parcelDate,
    this.parcelTime,
    this.reviewStar,
    this.paymentId,
    this.invoicePaymentStatus,
  });

  Delivered.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trackingId = json['tracking_id'];
    merchantId = json['merchant_id'];
    merchantName = json['merchant_name'];
    merchantUserName = json['merchant_user_name'];
    merchantUserEmail = json['merchant_user_email'];
    merchantMobile = json['merchant_mobile'];
    merchantAddress = json['merchant_address'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    customerAddress = json['customer_address'];
    shipmentType = json['shipment_type'];
    invoiceNo = json['invoice_no'];
    weight = json['weight'];
    totalDeliveryAmount = json['total_delivery_amount'];
    codAmount = json['cod_amount'];
    vatAmount = json['vat_amount'];
    currentPayable = json['current_payable'];
    cashCollection = json['cash_collection'];
    deliveryTypeId = json['delivery_type_id'];
    deliveryType = json['deliveryType'];
    status = json['status'];
    statusName = json['statusName'];
    pickupDate = json['pickup_date'];
    deliveryDate = json['delivery_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    parcelDate = json['parcel_date'];
    parcelTime = json['parcel_time'];
    reviewStar = json['review_star'];
    paymentId = json['payment_id'];
    invoicePaymentStatus = json['invoice_payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tracking_id'] = trackingId;
    data['merchant_id'] = merchantId;
    data['merchant_name'] = merchantName;
    data['merchant_user_name'] = merchantUserName;
    data['merchant_user_email'] = merchantUserEmail;
    data['merchant_mobile'] = merchantMobile;
    data['merchant_address'] = merchantAddress;
    data['customer_name'] = customerName;
    data['customer_phone'] = customerPhone;
    data['customer_address'] = customerAddress;
    data['shipment_type'] = shipmentType;
    data['invoice_no'] = invoiceNo;
    data['weight'] = weight;
    data['total_delivery_amount'] = totalDeliveryAmount;
    data['cod_amount'] = codAmount;
    data['vat_amount'] = vatAmount;
    data['current_payable'] = currentPayable;
    data['cash_collection'] = cashCollection;
    data['delivery_type_id'] = deliveryTypeId;
    data['deliveryType'] = deliveryType;
    data['status'] = status;
    data['statusName'] = statusName;
    data['pickup_date'] = pickupDate;
    data['delivery_date'] = deliveryDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['parcel_date'] = parcelDate;
    data['parcel_time'] = parcelTime;
    data['review_star'] = reviewStar;
    data['payment_id'] = paymentId;
    data['invoice_payment_status'] = invoicePaymentStatus;
    return data;
  }
}
