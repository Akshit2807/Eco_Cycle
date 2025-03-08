import 'package:e_waste/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

Padding buildSearchBar({required double padding}) {
  return Padding(
    padding: EdgeInsets.only(right: padding, left: padding),
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
