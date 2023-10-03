import 'dart:io';

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
  List<String>? hair = [];
  List<String>? makeup = [];
  List<String>? spa = [];
  List<String>? nails = [];
  List<String>? lashes = [];
  List<String>? wax = [];
  List<dynamic>? experiences = [];
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
    this.hair,
    this.makeup,
    this.spa,
    this.nails,
    this.lashes,
    this.wax,
    this.experiences,
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
