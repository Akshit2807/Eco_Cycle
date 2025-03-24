import 'package:e_waste/core/services/decide_service.dart';
import 'package:e_waste/core/utils/app_loader.dart';
import 'package:e_waste/data/models/decision_model.dart';
import 'package:e_waste/presentation/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DecideScreen extends StatefulWidget {
  final String qns;
  const DecideScreen({super.key, required this.qns});

  @override
  State<DecideScreen> createState() => _DecideScreenState();
}

class _DecideScreenState extends State<DecideScreen> {
  late Future<Decision> _response;

  @override
  void initState() {
    _response = DecideService.getGuide(widget.qns, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder<Decision>(
        future: _response.whenComplete(() async {
          Future.delayed(const Duration(milliseconds: 100));
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12),
                    child: customAppBar(
                      isHome: false,
                      title: snapshot.data!.decision,
                      rank: '12',
                      points: '40',
                      context: context,
                    ),
                  ),
                  Text(snapshot.data!.guide)
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          } else {
            return const Center(
              child: AppLoader(),
            );
          }
        },
      ),
    ));
  }
}
