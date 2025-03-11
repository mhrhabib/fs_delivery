class LoginModel {
  bool? success;
  String? message;
  Data? data;

  LoginModel({this.success, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  String? token;
  User? user;
  String? userType;

  Data({this.token, this.user, this.userType});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['user_type'] = userType;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? userType;
  SpotManager? spotManager;
  Hub? hub;
  String? address;
  String? salary;
  String? status;
  String? statusName;
  String? image;
  String? createdAt;
  String? updatedAt;

  User({this.id, this.name, this.email, this.phone, this.userType, this.spotManager, this.hub, this.address, this.salary, this.status, this.statusName, this.image, this.createdAt, this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    userType = json['user_type'];
    spotManager = json['spot_manager'] != null ? SpotManager.fromJson(json['spot_manager']) : null;
    hub = json['hub'] != null ? Hub.fromJson(json['hub']) : null;
    address = json['address'];
    salary = json['salary'];
    status = json['status'];
    statusName = json['statusName'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['user_type'] = userType;
    if (spotManager != null) {
      data['spot_manager'] = spotManager!.toJson();
    }
    if (hub != null) {
      data['hub'] = hub!.toJson();
    }
    data['address'] = address;
    data['salary'] = salary;
    data['status'] = status;
    data['statusName'] = statusName;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SpotManager {
  int? id;
  int? userId;
  String? spotUniqueId;
  int? nidId;
  int? tradeLicense;
  String? createdAt;
  String? updatedAt;

  SpotManager({this.id, this.userId, this.spotUniqueId, this.nidId, this.tradeLicense, this.createdAt, this.updatedAt});

  SpotManager.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    spotUniqueId = json['spot_unique_id'];
    nidId = json['nid_id'];
    tradeLicense = json['trade_license'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['spot_unique_id'] = spotUniqueId;
    data['nid_id'] = nidId;
    data['trade_license'] = tradeLicense;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Hub {
  int? id;
  String? name;
  dynamic ownerStoreOperatorName;
  dynamic descriptionOfShop;
  dynamic idNumber;
  dynamic kraPin;
  dynamic certificateOfGoodConduct;
  dynamic businessPermit;
  dynamic paymentPerPackage;
  String? phone;
  dynamic email;
  String? address;
  dynamic hubLat;
  dynamic hubLong;
  String? currentBalance;
  dynamic parcelStorageCapacity;
  dynamic fsStorageSpace;
  dynamic physicalAddress;
  dynamic fullAddress;
  dynamic location;
  dynamic countryId;
  dynamic zoneId;
  dynamic subZoneId;
  int? status;
  String? createdAt;
  String? updatedAt;

  Hub(
      {this.id,
      this.name,
      this.ownerStoreOperatorName,
      this.descriptionOfShop,
      this.idNumber,
      this.kraPin,
      this.certificateOfGoodConduct,
      this.businessPermit,
      this.paymentPerPackage,
      this.phone,
      this.email,
      this.address,
      this.hubLat,
      this.hubLong,
      this.currentBalance,
      this.parcelStorageCapacity,
      this.fsStorageSpace,
      this.physicalAddress,
      this.fullAddress,
      this.location,
      this.countryId,
      this.zoneId,
      this.subZoneId,
      this.status,
      this.createdAt,
      this.updatedAt});

  Hub.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ownerStoreOperatorName = json['owner_store_operator_name'];
    descriptionOfShop = json['description_of_shop'];
    idNumber = json['id_number'];
    kraPin = json['kra_pin'];
    certificateOfGoodConduct = json['certificate_of_good_conduct'];
    businessPermit = json['business_permit'];
    paymentPerPackage = json['payment_per_package'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    hubLat = json['hub_lat'];
    hubLong = json['hub_long'];
    currentBalance = json['current_balance'];
    parcelStorageCapacity = json['parcel_storage_capacity'];
    fsStorageSpace = json['fs_storage_space'];
    physicalAddress = json['physical_address'];
    fullAddress = json['full_address'];
    location = json['location'];
    countryId = json['country_id'];
    zoneId = json['zone_id'];
    subZoneId = json['sub_zone_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['owner_store_operator_name'] = ownerStoreOperatorName;
    data['description_of_shop'] = descriptionOfShop;
    data['id_number'] = idNumber;
    data['kra_pin'] = kraPin;
    data['certificate_of_good_conduct'] = certificateOfGoodConduct;
    data['business_permit'] = businessPermit;
    data['payment_per_package'] = paymentPerPackage;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address;
    data['hub_lat'] = hubLat;
    data['hub_long'] = hubLong;
    data['current_balance'] = currentBalance;
    data['parcel_storage_capacity'] = parcelStorageCapacity;
    data['fs_storage_space'] = fsStorageSpace;
    data['physical_address'] = physicalAddress;
    data['full_address'] = fullAddress;
    data['location'] = location;
    data['country_id'] = countryId;
    data['zone_id'] = zoneId;
    data['sub_zone_id'] = subZoneId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
