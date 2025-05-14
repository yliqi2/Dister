class Users {
  String uid;
  String username;
  String photo;
  List<String> followers;
  List<String> following;
  int listings;
  String? desc;
  int? age;
  String? phoneNumber;

  Users({
    required this.uid,
    required this.username,
    required this.photo,
    required this.followers,
    required this.following,
    required this.listings,
    this.desc,
    this.age,
    this.phoneNumber,
  });

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      photo: map['photo'] ?? '',
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      listings: map['listings'] ?? 0,
      desc: map['desc'] ?? '',
      age: map['age'],
      phoneNumber: map['phoneNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'photo': photo,
      'followers': followers,
      'following': following,
      'listings': listings,
      'desc': desc,
      'age': age,
      'phoneNumber': phoneNumber,
    };
  }
}
