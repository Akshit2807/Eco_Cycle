import 'package:audioplayers/audioplayers.dart';
import 'package:e_waste/core/router/app_router.dart';
import 'package:e_waste/core/services/local_storage_service/secure_storage.dart';
import 'package:e_waste/core/services/quetions_service.dart';
import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_loader.dart';
import 'package:e_waste/data/models/quetions_model.dart';
import 'package:e_waste/presentation/components/custom_app_bar.dart';
import 'package:e_waste/viewmodels/questions_viewmodel.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';

class QuetionsScreen extends StatefulWidget {
  final String title;
  const QuetionsScreen({super.key, required this.title});

  @override
  State<QuetionsScreen> createState() => _QuetionsScreenState();
}

class _QuetionsScreenState extends State<QuetionsScreen> {
  late Future<Quetions> _response;

  @override
  void initState() {
    _response = QuestionsService.getQuetions(widget.title, context);
    super.initState();
  }

  List<Widget> messages = [];
  List<String> que = [];
  int queIndex = 0;
  List<String> qns = [];
  bool visibility = true;
  final player = AudioPlayer();
  ScrollController scrollController = ScrollController();
  TextEditingController msgText = TextEditingController();
  void addItem() {
    if (msgText.text.isNotEmpty && queIndex - 1 < que.length) {
      setState(() {
        if (queIndex - 1 < que.length) {
          qns.add(
              "qns: \"${que.elementAt(queIndex - 1)}\", ans: \"${msgText.text}\"");
        } else {
          qns.add(
              "qns: \"${que.elementAt(queIndex)}\", ans: \"${msgText.text}\"");
        }
        player.play(AssetSource('msg_sound.mp3'));
        messages.add(
          messageTile(
              message: msgText.text,
              isMe: true,
              width: MediaQuery.of(context).size.width * 0.72),
        );

        if (queIndex < que.length) {
          player.play(AssetSource('msg_sound.mp3'));
          messages.add(
            messageTile(
                message: que.elementAt(queIndex),
                isMe: false,
                width: MediaQuery.of(context).size.width * 0.72),
          );
        } else if (queIndex >= que.length) {
          setState(() {
            visibility = false;
          });
        }
        queIndex++;
      });
      msgText.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.white,
      bottomSheet: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        color: AppColors.white,
        child: Visibility(
          visible: visibility,
          replacement: Row(
            children: [
              const SizedBox(
                width: 24,
              ),

              /// Back Button
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      SecureStorageService().deleteData("Base64Response");
                      SecureStorageService().deleteData("clickedImg");
                      SecureStorageService().deleteData("QuestionsFromAI");
                      Get.toNamed(RouteNavigation.navScreenRoute);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: const Size(double.maxFinite, 56),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: AppColors.green,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.transparent,
                    ),
                    child: CustomText(
                      textName: "Back",
                      textColor: AppColors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
              ),
              const SizedBox(
                width: 24,
              ),

              /// Continue Button
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Get.offNamed(RouteNavigation.decideScreenRoute,
                          arguments: {
                            'qns': qns.join(";"),
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: const Size(double.maxFinite, 56),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: AppColors.green,
                    ),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: CustomText(
                        textName: "Continue",
                        textColor: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )),
              ),
              const SizedBox(
                width: 24,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColors.green,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColors.green,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColors.green,
                        ),
                      ),
                      label: CustomText(
                        textName: "Message",
                        fontWeight: FontWeight.w400,
                        textColor: AppColors.green,
                      )),
                  controller: msgText,
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    fixedSize: const Size(40, 56),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.green,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: AppColors.white,
                  ),
                  onPressed: () {
                    addItem();
                  },
                  child: ImageIcon(
                    const AssetImage("assets/send_msg.png"),
                    size: 16,
                    color: AppColors.green,
                  ))
            ],
          ),
        ),
      ),
      body: FutureBuilder<Quetions>(
        future: _response.whenComplete(() async {
          Future.delayed(const Duration(milliseconds: 100));
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            que = snapshot.data!.questions;
            if (messages.isEmpty) {
              messages.add(messageTile(
                  message: que.elementAt(0),
                  isMe: false,
                  width: MediaQuery.of(context).size.width * 0.72));
              queIndex++;
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12),
                  child: customAppBar(
                    isHome: false,
                    title: "AI Chat Bot",
                    rank: '12',
                    points: '40',
                    prf: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20,
                              color: Colors.green.withValues(alpha: 0.2),
                            )
                          ],
                          image: const DecorationImage(
                              image: AssetImage("assets/chatbot.png"))),
                    ),
                    context: context,
                  ),
                ),
                Expanded(
                    child: GroupedListView<dynamic, int>(
                  reverse: true,
                  order: GroupedListOrder.DESC,
                  elements: messages,
                  groupBy: (element) => messages.indexOf(element, 0),
                  groupHeaderBuilder: (element) => const SizedBox(),
                  itemBuilder: (context, element) {
                    return element;
                  },
                )),
                const SizedBox(
                  height: 80,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Text("Something went wrong");
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
