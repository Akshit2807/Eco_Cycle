import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import '../core/utils/app_colors.dart';

Align messageTile(
    {required String message, required bool isMe, required double width}) {
  return Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isMe ? AppColors.placeHolder : AppColors.green,
      ),
      child: CustomText(
        textName: message,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    ),
  );
}
