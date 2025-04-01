import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:e_waste/core/router/app_router.dart';
import 'package:e_waste/core/services/local_storage_service/secure_storage.dart';
import 'package:e_waste/core/utils/app_colors.dart';
import 'package:e_waste/core/utils/app_loader.dart';
import 'package:e_waste/presentation/components/custom_app_bar.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class QuetionsScreen extends StatefulWidget {
  final String title;
  final String des;
  const QuetionsScreen({super.key, required this.title, required this.des});

  @override
  State<QuetionsScreen> createState() => _QuetionsScreenState();
}

class _QuetionsScreenState extends State<QuetionsScreen> with RouteAware {
  // WebSocket related variables
  WebSocketChannel? _channel;
  bool _isConnected = false;
  bool _isWaitingForResponse = false;

  List<String> qns = [];
  // Animation related variables
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<MessageItem> _messages = [];

  // Original variables
  final player = AudioPlayer();
  ScrollController scrollController = ScrollController();
  TextEditingController msgText = TextEditingController();

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();

    // Register to route observer to detect when user navigates away
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RouteObserver<PageRoute> routeObserver =
          Get.find<RouteObserver<PageRoute>>();
      routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    });
  }

  @override
  void dispose() {
    _channel?.sink.close(status.goingAway);
    msgText.dispose();
    scrollController.dispose();
    player.dispose();

    // Unsubscribe from route observer
    final RouteObserver<PageRoute> routeObserver =
        Get.find<RouteObserver<PageRoute>>();
    routeObserver.unsubscribe(this);

    super.dispose();
  }

  // Reset chat when navigating back to this screen
  @override
  void didPopNext() {
    super.didPopNext();
    _resetChat();
  }

  void _resetChat() {
    setState(() {
      // Clear messages
      final int count = _messages.length;
      for (int i = 0; i < count; i++) {
        _listKey.currentState?.removeItem(
          0,
          (context, animation) => _buildItem(context, _messages[0], animation),
          duration: const Duration(milliseconds: 200),
        );
        _messages.removeAt(0);
      }

      // Reset connection
      _channel?.sink.close(status.goingAway);
      _isConnected = false;
      _isWaitingForResponse = false;

      // Reconnect
      _connectToWebSocket();
    });
  }

  Future<void> _connectToWebSocket() async {
    try {
      String? token = await TokenService().getToken();
      _channel = IOWebSocketChannel.connect(
        Uri.parse(
            'wss://geminiapiwrap.onrender.com/chatqa/${widget.title}/${widget.des}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Replace with your actual token
        },
      );

      setState(() {
        _isConnected = true;
      });

      _channel!.stream.listen(
        (message) {
          // Play sound for incoming message
          player.play(AssetSource('msg_sound.mp3'));

          Future.delayed(const Duration(milliseconds: 50000));
          // Add the message to the chat with animation
          _addMessage(MessageItem(
            text: message.toString(),
            isMe: false,
          ));

          setState(() {
            _isWaitingForResponse = false;
          });

          _scrollToBottom();
        },
        onDone: () {
          setState(() {
            _isConnected = false;
            _isWaitingForResponse = false;
          });

          Get.offNamed(RouteNavigation.decideScreenRoute,
              arguments: {'qns': qns.toString()});

          log('WebSocket disconnected');
        },
        onError: (error) {
          setState(() {
            _isConnected = false;
            _isWaitingForResponse = false;
          });
          _showSnackBar('WebSocket error: $error');
          Get.offAllNamed(RouteNavigation.homeScreenRoute);
        },
      );
    } catch (e) {
      setState(() {
        _isConnected = false;
      });
      _showSnackBar('Failed to connect: $e');
      Get.offAllNamed(RouteNavigation.homeScreenRoute);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  void _addMessage(MessageItem message) {
    setState(() {
      _messages.insert(0, message); // Insert at the beginning for reverse list
      _listKey.currentState?.insertItem(
        0,
        duration: const Duration(milliseconds: 300),
      );
      if (message.isMe) {
        qns.add("ans: \"${message.text}\"");
      } else {
        qns.add("que: \"${message.text}\"");
      }
    });
    log(qns.toString());
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0, // Scroll to top for reverse list
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage() {
    if (msgText.text.isNotEmpty && _isConnected) {
      final String messageText = msgText.text;

      // Play sound for outgoing message
      player.play(AssetSource('msg_sound.mp3'));

      // Add the message to the chat with animation
      _addMessage(MessageItem(
        text: messageText,
        isMe: true,
      ));

      // Send the message through WebSocket
      _channel!.sink.add(messageText);

      setState(() {
        _isWaitingForResponse = true;
      });

      // Clear the text field
      msgText.clear();

      _scrollToBottom();
    }
  }

  Widget _buildItem(
      BuildContext context, MessageItem message, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: FadeTransition(
        opacity: animation,
        child: messageTile(
          message: message.text,
          isMe: message.isMe,
          width: MediaQuery.of(context).size.width * 0.72,
        ),
      ),
    );
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
                    ),
                    suffixIcon: _isWaitingForResponse
                        ? Container(
                            margin: const EdgeInsets.all(8),
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.green,
                            ),
                          )
                        : null,
                  ),
                  controller: msgText,
                  enabled: _isConnected && !_isWaitingForResponse,
                  onFieldSubmitted: (_) => sendMessage(),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: AppColors.white,
                ),
                onPressed:
                    _isConnected && !_isWaitingForResponse ? sendMessage : null,
                child: ImageIcon(
                  const AssetImage("assets/send_msg.png"),
                  size: 16,
                  color: _isConnected && !_isWaitingForResponse
                      ? AppColors.green
                      : AppColors.green.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
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
                        color: Colors.green.withAlpha(51),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage("assets/chatbot.png"),
                    ),
                  ),
                ),
                context: context,
              ),
            ),
            Expanded(
              child: _messages.isEmpty
                  ? const Center(child: AppLoader())
                  : AnimatedList(
                      key: _listKey,
                      controller: scrollController,
                      reverse: true, // Display messages from bottom to top
                      initialItemCount: _messages.length,
                      itemBuilder: (context, index, animation) {
                        return _buildItem(context, _messages[index], animation);
                      },
                    ),
            ),
            // Typing indicator
            if (_isWaitingForResponse)
              const Padding(
                padding: EdgeInsets.only(left: 16, bottom: 6, top: 30),
                child: TypingIndicator(),
              ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}

// Message item class to store message data
class MessageItem {
  final String text;
  final bool isMe;

  MessageItem({required this.text, required this.isMe});
}

// Add the TypingIndicator widget from your first file
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 0;
  final List<String> _dots = ['', '.', '..', '...'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        if (_controller.status == AnimationStatus.completed) {
          _controller.reset();
          setState(() {
            _currentIndex = (_currentIndex + 1) % _dots.length;
          });
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
              textName: 'AI is thinking',
              textColor: AppColors.dark,
              fontWeight: FontWeight.bold,
              fontSize: 16),
          CustomText(
            textName: _dots[_currentIndex],
            textColor: AppColors.dark,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}

// Assuming this function is defined elsewhere in your code
// If not, you'll need to implement it based on your UI requirements
Widget messageTile({
  required String message,
  required bool isMe,
  required double width,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
    child: Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: width,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
            color: isMe ? AppColors.green : AppColors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: CustomText(
            textName: message,
            textColor: isMe ? Colors.white : AppColors.green,
          ),
        ),
      ],
    ),
  );
}
