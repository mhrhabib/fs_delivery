class DashboardModel {
  bool? success;
  String? message;
  Data? data;

  DashboardModel({this.success, this.message, this.data});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Parcel>? pendingParcel;
  List<Parcel>? acceptParcel;
  List<Parcel>? releaseParcel;
  List<Parcel>? allParcel;

  Data({this.pendingParcel, this.acceptParcel, this.releaseParcel, this.allParcel});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['pending_parcel'] != null) {
      pendingParcel = <Parcel>[];
      json['pending_parcel'].forEach((v) {
        pendingParcel!.add(new Parcel.fromJson(v));
      });
    }
    if (json['accept_parcel'] != null) {
      acceptParcel = <Parcel>[];
      json['accept_parcel'].forEach((v) {
        acceptParcel!.add(new Parcel.fromJson(v));
      });
    }
    if (json['release_parcel'] != null) {
      releaseParcel = <Parcel>[];
      json['release_parcel'].forEach((v) {
        releaseParcel!.add(new Parcel.fromJson(v));
      });
    }
    if (json['all_parcel'] != null) {
      allParcel = <Parcel>[];
      json['all_parcel'].forEach((v) {
        allParcel!.add(new Parcel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (pendingParcel != null) {
      data['pending_parcel'] = pendingParcel!.map((v) => v.toJson()).toList();
    }
    if (acceptParcel != null) {
      data['accept_parcel'] = acceptParcel!.map((v) => v.toJson()).toList();
    }
    if (releaseParcel != null) {
      data['release_parcel'] = releaseParcel!.map((v) => v.toJson()).toList();
    }
    if (allParcel != null) {
      data['all_parcel'] = allParcel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parcel {
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
  dynamic reviewStar;

  Parcel(
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

  Parcel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
