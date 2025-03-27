import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/extensions.dart';
import 'package:e_waste/data/models/decision_model.dart';
import 'package:e_waste/presentation/components/custom_app_bar.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class RecycleScreen extends StatelessWidget {
  final AsyncSnapshot<Decision> snapshot;
  const RecycleScreen({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// App Bar
              customAppBar(
                isHome: false,
                title: snapshot.data!.decision.capitalizeFirstOfEach,
                rank: '12',
                points: '40',
                context: context,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomText(
                textName: "Nearby locations to dispose E-Waste",
                fontWeight: FontWeight.w600,
                fontSize: 20,
                textColor: AppColors.green,
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 400,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.dark, width: 2)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.location_on_rounded,
                        color: AppColors.dark,
                      ),
                      title: CustomText(
                        textName: "Nearby location",
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        textColor: AppColors.dark,
                      ),
                      trailing: CustomText(
                        textName: "3KM",
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        textColor: AppColors.dark,
                      ),
                      tileColor: AppColors.green.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.location_on_rounded,
                        color: AppColors.dark,
                      ),
                      title: CustomText(
                        textName: "Nearby location",
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        textColor: AppColors.dark,
                      ),
                      trailing: CustomText(
                        textName: "3KM",
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        textColor: AppColors.dark,
                      ),
                      tileColor: AppColors.green.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.location_on_rounded,
                        color: AppColors.dark,
                      ),
                      title: CustomText(
                        textName: "Nearby location",
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        textColor: AppColors.dark,
                      ),
                      trailing: CustomText(
                        textName: "3KM",
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        textColor: AppColors.dark,
                      ),
                      tileColor: AppColors.green.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.location_on_rounded,
                        color: AppColors.dark,
                      ),
                      title: CustomText(
                        textName: "Nearby location",
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        textColor: AppColors.dark,
                      ),
                      trailing: CustomText(
                        textName: "3KM",
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        textColor: AppColors.dark,
                      ),
                      tileColor: AppColors.green.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.location_on_rounded,
                        color: AppColors.dark,
                      ),
                      title: CustomText(
                        textName: "Nearby location",
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        textColor: AppColors.dark,
                      ),
                      trailing: CustomText(
                        textName: "3KM",
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        textColor: AppColors.dark,
                      ),
                      tileColor: AppColors.green.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              Container(
                height: 170,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.dark, width: 2)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.fire_truck,
                        color: AppColors.white,
                      ),
                      title: CustomText(
                        textName: "Scedule Pickup",
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        textColor: AppColors.white,
                      ),
                      tileColor: AppColors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.location_on_rounded,
                        color: AppColors.white,
                      ),
                      title: CustomText(
                        textName: "Book appointment",
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        textColor: AppColors.white,
                      ),
                      tileColor: AppColors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
