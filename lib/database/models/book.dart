// ignore_for_file: public_member_api_docs

class Book {
  Book({
    this.id,
    this.title,
    this.price,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: int.tryParse(json['id'].toString()),
      title: json['title'] as String?,
      price: double.tryParse(json['price'].toString()),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
    };
  }

  Book copy(Book book) {
    return Book(
      id: book.id ?? id,
      title: book.title ?? title,
      price: book.price ?? price,
      description: book.description ?? description,
    );
  }

  Book copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
    );
  }

  final int? id;
  final String? title;
  final double? price;
  final String? description;
}
