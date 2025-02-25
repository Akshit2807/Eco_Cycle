import 'package:e_waste/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

Padding buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.only(right: 24, left: 24),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(Icons.search, color: AppColors.dark),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                    color: AppColors.dark, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
