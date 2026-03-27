import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum ExpenseCategory {
  food,
  transport,
  shopping,
  bills,
  entertainment,
  health,
  education,
  other,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.bills:
        return 'Bills';
      case ExpenseCategory.entertainment:
        return 'Entertainment';
      case ExpenseCategory.health:
        return 'Health';
      case ExpenseCategory.education:
        return 'Education';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.food:
        return Icons.restaurant_rounded;
      case ExpenseCategory.transport:
        return Icons.directions_car_rounded;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag_rounded;
      case ExpenseCategory.bills:
        return Icons.receipt_long_rounded;
      case ExpenseCategory.entertainment:
        return Icons.movie_rounded;
      case ExpenseCategory.health:
        return Icons.medical_services_rounded;
      case ExpenseCategory.education:
        return Icons.school_rounded;
      case ExpenseCategory.other:
        return Icons.more_horiz_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.food:
        return AppColors.food;
      case ExpenseCategory.transport:
        return AppColors.transport;
      case ExpenseCategory.shopping:
        return AppColors.shopping;
      case ExpenseCategory.bills:
        return AppColors.bills;
      case ExpenseCategory.entertainment:
        return AppColors.entertainment;
      case ExpenseCategory.health:
        return AppColors.health;
      case ExpenseCategory.education:
        return AppColors.education;
      case ExpenseCategory.other:
        return AppColors.other;
    }
  }
}

class Expense extends Equatable {
  final int? id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String? description;
  final DateTime createdAt;

  const Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, amount, category, date, description, createdAt];

  Expense copyWith({
    int? id,
    String? title,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
    String? description,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
