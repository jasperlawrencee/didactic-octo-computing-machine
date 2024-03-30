import 'dart:io';

import 'package:flutter_auth/Screens/SalonRegister/register_stepper.dart';
import 'package:flutter_auth/Screens/WorkerRegister/register_stepper.dart';
import 'package:flutter_auth/models/experience.dart';
import 'package:image_picker/image_picker.dart';

bool workerFormComplete() {
  var fields = [
    workerForm.firstName,
    workerForm.lastName,
    workerForm.gender,
    workerForm.phoneNum1,
    workerForm.city,
    workerForm.barangay,
    workerForm.stAddress,
    workerForm.hair,
    workerForm.makeup,
    workerForm.spa,
    workerForm.nails,
    workerForm.lashes,
    workerForm.wax,
    workerForm.governmentID,
    workerForm.vaxCard,
    workerForm.nbiClearance,
    workerForm.tinID,
    workerForm.certificates,
  ];

  bool filledAny = workerForm.hair.isNotEmpty ||
      workerForm.makeup.isNotEmpty ||
      workerForm.spa.isNotEmpty ||
      workerForm.nails.isNotEmpty ||
      workerForm.lashes.isNotEmpty ||
      workerForm.wax.isNotEmpty;
  bool checkedAny = workerForm.isHairClicked == true ||
      workerForm.isMakeupClicked == true ||
      workerForm.isSpaClicked == true ||
      workerForm.isNailsClicked == true ||
      workerForm.isLashesClicked == true ||
      workerForm.isWaxClicked == true;
  bool complete = !fields.any((element) => element == null || element == '') &&
      checkedAny == true &&
      filledAny == true;
  return complete;
}

bool salonFormComplete() {
  var fields = [
    salonForm.salonName,
    salonForm.roomBuilding,
    salonForm.barangay,
    salonForm.city,
    salonForm.salonOwner,
    salonForm.salonNumber,
    salonForm.salonRepresentative,
    salonForm.representativeEmail,
    salonForm.representativeNum,
    salonForm.representativeID,
    salonForm.hair,
    salonForm.makeup,
    salonForm.spa,
    salonForm.nails,
    salonForm.lashes,
    salonForm.wax,
    salonForm.businessPermit,
    salonForm.outsideSalonPhoto,
    salonForm.insideSalonPhoto,
  ];
  bool filledAny = salonForm.hair.isNotEmpty ||
      salonForm.makeup.isNotEmpty ||
      salonForm.spa.isNotEmpty ||
      salonForm.nails.isNotEmpty ||
      salonForm.lashes.isNotEmpty ||
      salonForm.wax.isNotEmpty;
  bool checkedAny = salonForm.isHairClicked == true ||
      salonForm.isMakeupClicked == true ||
      salonForm.isSpaClicked == true ||
      salonForm.isNailsClicked == true ||
      salonForm.isLashesClicked == true ||
      salonForm.isWaxClicked == true;
  bool complete = !fields.any((element) => element == null || element == '') &&
      checkedAny == true &&
      filledAny == true;
  return complete;
}

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
  String? salonEmployed;
  List<String> hair = [];
  bool isHairClicked = false;
  List<String> makeup = [];
  bool isMakeupClicked = false;
  List<String> spa = [];
  bool isSpaClicked = false;
  List<String> nails = [];
  bool isNailsClicked = false;
  List<String> lashes = [];
  bool isLashesClicked = false;
  List<String> wax = [];
  bool isWaxClicked = false;
  List<Experience> experiences = [];
  List<String> salonExperiences = [];
  bool isExperienceClicked = false;
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
    this.salonEmployed,
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
  List<String> hair = [];
  bool isHairClicked = false;
  List<String> makeup = [];
  bool isMakeupClicked = false;
  List<String> spa = [];
  bool isSpaClicked = false;
  List<String> nails = [];
  bool isNailsClicked = false;
  List<String> lashes = [];
  bool isLashesClicked = false;
  List<String> wax = [];
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
