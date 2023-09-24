import 'package:image_picker/image_picker.dart';

class WorkerForm {
  String firstName;
  String middleName;
  String lastName;
  String phoneNum1;
  String phoneNum2;
  String city;
  String barangay;
  String stAddress;
  String extAddress;

  WorkerForm(
      this.firstName,
      this.middleName,
      this.lastName,
      this.phoneNum1,
      this.phoneNum2,
      this.city,
      this.barangay,
      this.stAddress,
      this.extAddress);
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
  XFile image;

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
      this.image);
}
