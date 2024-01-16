import 'dart:io';

import 'package:flutter_auth/models/experience.dart';
import 'package:image_picker/image_picker.dart';

class WorkerForm {
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? phoneNum1;
  String? phoneNum2;
  String? city;
  String? barangay;
  String? stAddress;
  String? extAddress;
  String? birthday;
  List<String> hair = ['Hair Services'];
  bool isHairClicked = false;
  List<String> makeup = ['Makeup Services'];
  bool isMakeupClicked = false;
  List<String> spa = ['Spa Services'];
  bool isSpaClicked = false;
  List<String> nails = ['Nails Services'];
  bool isNailsClicked = false;
  List<String> lashes = ['Lashes Services'];
  bool isLashesClicked = false;
  List<String> wax = ['Wax Services'];
  bool isWaxClicked = false;
  List<Experience> experiences = [];
  File? governmentID;
  File? vaxCard;
  File? nbiClearance;
  String? tinID;
  List? certificates = <XFile>[];
  bool verified = false;

  WorkerForm({
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.phoneNum1,
    this.phoneNum2,
    this.city,
    this.barangay,
    this.stAddress,
    this.extAddress,
    this.birthday,
    required this.hair,
    required this.makeup,
    required this.spa,
    required this.nails,
    required this.lashes,
    required this.wax,
    this.governmentID,
    this.vaxCard,
    this.nbiClearance,
    this.tinID,
    this.certificates,
  });
}

class SalonForm {
  String salonName;
  String roomBuilding;
  String streetRoad;
  String barangay;
  String city;
  String salonOwner;
  String salonNumber;
  String salonRepresentative;
  String representativeEmail;
  String representativeNum;
  List<String> hair = ['Hair Services'];
  bool isHairClicked = false;
  List<String> makeup = ['Makeup Services'];
  bool isMakeupClicked = false;
  List<String> spa = ['Spa Services'];
  bool isSpaClicked = false;
  List<String> nails = ['Nails Services'];
  bool isNailsClicked = false;
  List<String> lashes = ['Lashes Services'];
  bool isLashesClicked = false;
  List<String> wax = ['Wax Services'];
  bool isWaxClicked = false;
  File? representativeID;
  File? businessPermit;
  File? secondaryLicense;
  File? outsideSalonPhoto;
  File? insideSalonPhoto;
  bool verified = false;

  SalonForm({
    required this.salonName,
    required this.roomBuilding,
    required this.streetRoad,
    required this.barangay,
    required this.city,
    required this.salonOwner,
    required this.salonNumber,
    required this.salonRepresentative,
    required this.representativeEmail,
    required this.representativeNum,
    this.representativeID,
    this.businessPermit,
    this.secondaryLicense,
    this.outsideSalonPhoto,
    this.insideSalonPhoto,
  });
}
