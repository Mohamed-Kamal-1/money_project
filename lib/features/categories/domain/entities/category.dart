class Category {
  final String? id;
  final String? userId;
  final String? name;
  final String? icon; // يتم حفظ النص مباشرة (الإيموجي) دون الحاجة لـ codePoint
  final String? color;
  final String? type;
  final double? budget;
  final DateTime createdAt;

  const Category({
    this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    this.budget,
    required this.createdAt,
  });
}
