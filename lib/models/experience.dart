class Experience {
  String? name;
  String? address;
  String? contactNum;
  String? date;

  String log() {
    return "Name: $name\nAddress: $address\nContact Number: $contactNum\nDate: $date";
  }

  Map<String, dynamic> toFirebase() {
    return {
      'name': name,
      'address': address,
      'contactNum': contactNum,
      'duration': date,
    };
  }
}
