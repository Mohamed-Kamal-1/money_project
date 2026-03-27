import 'package:cloud_firestore/cloud_firestore.dart';

class AppTransaction {
  final String? id;
  final String userId;
  final String categoryId;
  final String categoryName;
  final double amount;
  final String type; // 'income' or 'expense'
  final String description; // خليناها اختيارية في الـ Constructor لراحة المستخدم
  final DateTime date;
  final String? notes;
  final DateTime createdAt;

  AppTransaction({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    this.type = 'expense',
    this.description = '', // قيمة افتراضية عشان الـ Dialog مش بياخد وصف حالياً
    DateTime? date,
    this.notes,
    DateTime? createdAt,
  })  : date = date ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  // تحويل لـ JSON عشان Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'amount': amount,
      'type': type,
      'description': description,
      'date': Timestamp.fromDate(date),
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // بناء الكائن من بيانات Firestore
  factory AppTransaction.fromJson(Map<String, dynamic> json, String id) {
    return AppTransaction(
      id: id,
      userId: json['userId'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? 'uncategorized',
      categoryName: json['categoryName'] as String? ?? 'General',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] as String? ?? 'expense',
      description: json['description'] as String? ?? '',
      date: json['date'] is Timestamp
          ? (json['date'] as Timestamp).toDate()
          : DateTime.now(),
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  factory AppTransaction.fromFirestore(DocumentSnapshot doc) {
    return AppTransaction.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }

  // الـ CopyWith مهم جداً للـ Cubit لو حبيت تعدل حالة معينة
  AppTransaction copyWith({
    String? id,
    String? userId,
    String? categoryId,
    String? categoryName,
    double? amount,
    String? type,
    String? description,
    DateTime? date,
    String? notes,
    DateTime? createdAt,
  }) {
    return AppTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      description: description ?? this.description,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}