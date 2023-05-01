// ignore_for_file: public_member_api_docs

class User {
  User({
    this.id,
    this.name,
    this.age,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.tryParse(json['id'].toString()),
      name: json['name'] as String?,
      age: int.tryParse(json['age'].toString()),
      image: json['image'] as String?,
      //!= null ? Uint8List.fromList(json['image'].codeUnits ) : null,
      //json['image'] != null ? Blob.fromBytes(json['image'].codeUnits) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'image': image, //?.toString(),
    };
  }

  User copyWith({
    int? id,
    String? name,
    int? age,
    String? image,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      image: image ?? this.image,
    );
  }

  final int? id;
  final String? name;
  final int? age;
  final String? image;
}
