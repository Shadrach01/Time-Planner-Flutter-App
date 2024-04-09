class UserData {
  final String userName;
  UserData({required this.userName});

  Map<String, dynamic> toMap() {
    return {'userName': userName};
  }

  static UserData fromMap(Map<String, dynamic> map) {
    return UserData(userName: map['userName']);
  }
}
