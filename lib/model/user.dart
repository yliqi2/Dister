class Users {
  String uid;
  String username;
  String photo;
  int followers;
  int following;
  int listings;
  String? desc;

  Users({
    required this.uid,
    required this.username,
    required this.photo,
    required this.followers,
    required this.following,
    required this.listings,
    this.desc,
  });

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      uid: map['uid'] ?? '', // Provide default values if the field is missing
      username: map['username'] ?? '',
      photo: map['photo'] ?? '',
      followers: map['followers'] ?? 0,
      following: map['following'] ?? 0,
      listings: map['listings'] ?? 0,
      desc: map['desc'] ?? '',
    );
  }

  // Convert Users object to a Map (optional, in case you want to update Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'photo': photo,
      'followers': followers,
      'following': following,
      'listings': listings,
      'desc': desc,
    };
  }
}
