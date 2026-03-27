import 'package:floor/floor.dart';
import '../../domain/entities/expense.dart';

@Entity(tableName: 'expenses')
class ExpenseModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'title')
  final String title;

  @ColumnInfo(name: 'amount')
  final double amount;

  @ColumnInfo(name: 'category')
  final String categoryString;

  @ColumnInfo(name: 'date')
  final int dateTimestamp;

  @ColumnInfo(name: 'description')
  final String? description;

  @ColumnInfo(name: 'created_at')
  final int createdAtTimestamp;

  ExpenseModel({
    this.id,
    required this.title,
    required this.amount,
    required this.categoryString,
    required this.dateTimestamp,
    this.description,
    required this.createdAtTimestamp,
  });

  // Factory constructor from Entity
  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      title: expense.title,
      amount: expense.amount,
      categoryString: expense.category.name,
      dateTimestamp: expense.date.millisecondsSinceEpoch,
      description: expense.description,
      createdAtTimestamp: expense.createdAt.millisecondsSinceEpoch,
    );
  }

  // Convert to Entity
  Expense toEntity() {
    return Expense(
      id: id,
      title: title,
      amount: amount,
      category: _categoryFromString(categoryString),
      date: DateTime.fromMillisecondsSinceEpoch(dateTimestamp),
      description: description,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtTimestamp),
    );
  }

  // Factory constructor from JSON (for API responses)
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      categoryString: json['category'],
      dateTimestamp: json['date'],
      description: json['description'],
      createdAtTimestamp: json['created_at'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': categoryString,
      'date': dateTimestamp,
      'description': description,
      'created_at': createdAtTimestamp,
    };
  }

  static ExpenseCategory _categoryFromString(String category) {
    return ExpenseCategory.values.firstWhere(
      (e) => e.name == category,
      orElse: () => ExpenseCategory.other,
    );
  }
}
