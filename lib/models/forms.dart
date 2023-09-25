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
  List? hair = [];
  List? makeup = [];
  List? spa = [];
  List? nails = [];
  List? lashes = [];
  List? wax = [];
  List? experiences = [];
  XFile? governmentID;
  XFile? vaxCard;
  XFile? nbiClearance;
  String? tinID;
  List? certificates = <XFile>[];

  WorkerForm(
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
  );
}

class SalonForm {
  String? salonName;
  String? roomBuilding;
  String? streetRoad;
  String? barangay;
  String? city;
  String? salonOwner;
  String? salonNumber;
  String? salonRepresentative;
  String? representativeEmail;
  String? representativeNum;
  XFile? representativeID;
  XFile? businessPermit;
  XFile? secondaryLicense;
  XFile? outsideSalonPhoto;
  XFile? insideSalonPhoto;

  SalonForm(
    this.salonName,
    this.roomBuilding,
    this.streetRoad,
    this.barangay,
    this.city,
    this.salonOwner,
    this.salonNumber,
    this.salonRepresentative,
    this.representativeEmail,
    this.representativeNum,
    this.representativeID,
    this.businessPermit,
    this.secondaryLicense,
    this.outsideSalonPhoto,
    this.insideSalonPhoto,
  );
}
