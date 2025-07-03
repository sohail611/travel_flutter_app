class Users {
  late String userId;
  late String email;
  late String phoneNo;

  Users(
      {required this.userId,
      required this.email,
      required this.phoneNo});

  Users.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    phoneNo = json['phoneNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['email'] = this.email;
    data['phoneNo'] = this.phoneNo;
    return data;
  }
}
class FavoriteItem {
  final String title;
  final String imageUrl;
  final String date;

  FavoriteItem({
    required this.title,
    required this.imageUrl,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'date': date,
    };
  }

  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      title: map['title'],
      imageUrl: map['imageUrl'],
      date: map['date'],
    );
  }
}
