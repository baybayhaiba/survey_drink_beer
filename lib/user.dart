class User {
  String name;
  DateTime dateOfBirth;
  String gender;
  String phoneNumber;
  String district;
  String ward;
  String address;

  User({
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    required this.district,
    required this.ward,
    required this.address,
  });

  static User get aboutMe =>
      User(name: "Huy Pham",
          dateOfBirth: DateTime.now(),
          gender: "male",
          phoneNumber: "1234567890",
          district: cities.first,
          ward: wards.first,
          address: "90 nam cao");


          static List<String> get cities => ["Thành phố Thủ Đức"];
          static List<String> get wards => ["Phường Trường Thạnh"];

  @override
  String toString() {
    return 'User{name: $name, dateOfBirth: $dateOfBirth, gender: $gender, phoneNumber: $phoneNumber, district: $district, ward: $ward, address: $address}';
  }
}