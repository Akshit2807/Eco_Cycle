import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension PercentSizedBox on SizedBox {
  static SizedBox all(double heightWidthPercent, {Widget? child}) => SizedBox(
        height: Get.height * heightWidthPercent,
        width: Get.width * heightWidthPercent,
        child: child,
      );
  static SizedBox width(double widthPercent, {Widget? child}) => SizedBox(
        width: Get.width * widthPercent,
        child: child,
      );
  static SizedBox height(double heightPercent, {Widget? child}) => SizedBox(
        height: Get.height * heightPercent,
        child: child,
      );
}
