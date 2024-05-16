class GetRegistrationModel {
  int id = 0;
  String? memberID;
  String? memberName;
  String? lastName;
  String? gender;
  String? maritalStatus;
  String? age;
  String? address;
  String? phone;
  String? email;
  String? occupation;
  String? representative;
  String? rate;
  String? location;


  GetRegistrationModel(
      this.id,
      this.memberID,
      this.memberName,
      this.lastName,
      this.gender,
      this.maritalStatus,
      this.age,
      this.address,
      this.phone,
      this.email,
      this.occupation,
      this.representative,
      this.rate,
      this.location
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id':id,
      'memberID': memberID,
      'memberName': memberName,
      'lastName':lastName,
      'gender' : gender,
      'maritalStatus' : maritalStatus,
      'age' : age,
      'address' : address,
      'phone' : phone,
      'email' : email,
      'occupation' : occupation,
      'representative' : representative,
      'rate' : rate,
      'location' : location,

    };
    return map;
  }

  GetRegistrationModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    memberID = map['memberID'];
    memberName = map['memberName'];
    lastName = map['lastName'];
    gender = map['gender'];
    maritalStatus = map['maritalStatus'];
    age = map['age'];
    address = map['address'];
    phone = map['email'];
    occupation = map['occupation'];
    representative =map['representative'];
    rate = map['rate'];
    location = map['location'];
  }
}
