import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  String? name;
  String? img;
  String? caption;
  double? price;
  double? discount;
  int? quantity;
  String? features;
  String? specifications;
  bool? domicileAvailable;
  double? domicileCost;
  String? deliveryAddress;
  String? propertyType;
  String? roomType;
  int? rooms;
  String? services;
  bool? petsAllowed;
  DateTime? checkInTime;
  DateTime? checkOutTime;
  Timestamp? rentalStartDate;
  Timestamp? rentalEndDate;
  String? toyLocation;
  bool? donateToy;
  String? category;
  // Add other fields as needed

  String? userUuidOfPost;
  Timestamp? createdAt;

  // User details
  String? userName;
  String? profilePictureOfUser;

  Food({
    this.name,
    this.img,
    this.caption,
    this.price,
    this.discount,
    this.quantity,
    this.features,
    this.specifications,
    this.domicileAvailable,
    this.domicileCost,
    this.deliveryAddress,
    this.propertyType,
    this.roomType,
    this.rooms,
    this.services,
    this.petsAllowed,
    this.checkInTime,
    this.checkOutTime,
    this.rentalStartDate,
    this.rentalEndDate,
    this.toyLocation,
    this.donateToy,
    this.category,
    this.userUuidOfPost,
    this.createdAt,
    this.userName,
    this.profilePictureOfUser,
  });

  Food.fromMap(Map<String, dynamic> data) {
    name = data['name'];
    img = data['img'];
    caption = data['caption'];
    price = data['price'];
    discount = data['discount'];
    quantity = data['quantity'];
    features = data['features'];
    specifications = data['specifications'];
    domicileAvailable = data['domicileAvailable'];
    domicileCost = data['domicileCost'];
    deliveryAddress = data['deliveryAddress'];
    propertyType = data['propertyType'];
    roomType = data['roomType'];
    rooms = data['rooms'];
    services = data['services'];
    petsAllowed = data['petsAllowed'];
    checkInTime = data['checkInTime'];
    checkOutTime = data['checkOutTime'];
    rentalStartDate = data['rentalStartDate'];
    rentalEndDate = data['rentalEndDate'];
    toyLocation = data['toyLocation'];
    donateToy = data['donateToy'];
    category = data['category'];
    userUuidOfPost = data['userUuidOfPost'];
    createdAt = data['createdAt'];
    userName = data['userName'];
    profilePictureOfUser = data['profilePictureOfUser'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'img': img,
      'caption': caption,
      'price': price,
      'discount': discount,
      'quantity': quantity,
      'features': features,
      'specifications': specifications,
      'domicileAvailable': domicileAvailable,
      'domicileCost': domicileCost,
      'deliveryAddress': deliveryAddress,
      'propertyType': propertyType,
      'roomType': roomType,
      'rooms': rooms,
      'services': services,
      'petsAllowed': petsAllowed,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'rentalStartDate': rentalStartDate,
      'rentalEndDate': rentalEndDate,
      'toyLocation': toyLocation,
      'donateToy': donateToy,
      'category': category,
      'userUuidOfPost': userUuidOfPost,
      'createdAt': createdAt,
      'userName': userName,
      'profilePictureOfUser': profilePictureOfUser,
    };
  }
}
