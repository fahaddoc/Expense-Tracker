import 'package:flutter/material.dart';
import '../../domain/entities/expense.dart';

class CategoryChip extends StatelessWidget {
  final ExpenseCategory category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? category.color : category.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: category.color,
            width: isSelected ? 0 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 18,
              color: isSelected ? Colors.white : category.color,
            ),
            const SizedBox(width: 8),
            Text(
              category.displayName,
              style: TextStyle(
                color: isSelected ? Colors.white : category.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryChipList extends StatelessWidget {
  final ExpenseCategory? selectedCategory;
  final Function(ExpenseCategory?) onCategorySelected;
  final bool showAll;

  const CategoryChipList({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
    this.showAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (showAll)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onCategorySelected(null),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedCategory == null
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'All',
                    style: TextStyle(
                      color: selectedCategory == null
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ...ExpenseCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CategoryChip(
                category: category,
                isSelected: selectedCategory == category,
                onTap: () => onCategorySelected(category),
              ),
            );
          }),
        ],
      ),
    );
  }
}
