import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Category {
  final String? id;
  final String userId;
  final String name;
  final int colorValue; // Storing color as int
  final String iconName; // Name of the icon (e.g., 'restaurant', 'directions_car')
  final double? budget;
  final DateTime createdAt;

  Category({
    this.id,
    required this.userId,
    required this.name,
    required this.colorValue,
    required this.iconName,
    this.budget,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Get color from colorValue
  Color get color => Color(colorValue);

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'colorValue': colorValue,
      'iconName': iconName,
      'budget': budget,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory Category.fromJson(Map<String, dynamic> json, String id) {
    return Category(
      id: id,
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      colorValue: json['colorValue'] as int? ?? 0xFFFF6B35,
      iconName: json['iconName'] as String? ?? 'shopping_bag',
      budget: (json['budget'] as num?)?.toDouble(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create from DocumentSnapshot
  factory Category.fromFirestore(DocumentSnapshot doc) {
    return Category.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }

  // Copy with method
  Category copyWith({
    String? id,
    String? userId,
    String? name,
    int? colorValue,
    String? iconName,
    double? budget,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      iconName: iconName ?? this.iconName,
      budget: budget ?? this.budget,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
