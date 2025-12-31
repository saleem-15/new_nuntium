class News {
  final String id; // أساسي للتعامل مع Firebase
  final String title;
  final String category;
  final String imageUrl;
  bool isSaved;

  News({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    this.isSaved = false,
  });

  // تحويل الكائن إلى Map لإرساله إلى Firestore
  Map<String, dynamic> toMap() {
    return {
      // الـ ID غالباً لا يرسل داخل الـ Map لأنه هو اسم الـ Document نفسه
      // ولكن نضعه هنا إذا أردت تخزينه كحقل إضافي
      'title': title,
      'category': category,
      'imageUrl': imageUrl,
      'isSaved': isSaved,
    };
  }

  // تحويل البيانات القادمة من Firestore (Map) إلى كائن News
  // أضفنا الـ id كمعامل منفصل لأن Firestore يعطينا الـ ID بشكل منفصل عن البيانات
  factory News.fromMap(Map<String, dynamic> map, String documentId) {
    return News(
      id: documentId,
      title: map['title'] ?? '',
      category: map['category'] ?? 'General',
      imageUrl: map['imageUrl'] ?? '',
      isSaved: map['isSaved'] ?? false,
    );
  }

  // لعمل نسخة معدلة من الكائن (مثلاً لتغيير حالة isSaved فقط)
  News copyWith({
    String? id,
    String? title,
    String? category,
    String? imageUrl,
    bool? isSaved,
  }) {
    return News(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is News && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'News(id: $id, title: $title, category: $category)';
}
