import 'package:e_waste/presentation/screens/ai_classification/recycle_screen.dart';
import 'package:e_waste/presentation/screens/ai_classification/resell_screen.dart';
import 'package:e_waste/presentation/screens/drawer_screen/faq_screen.dart';
import 'package:e_waste/presentation/screens/drawer_screen/help.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import '../../presentation/auth_check_navigator.dart';
import '../../presentation/components/reward_components/leaderboard_screen.dart';
import '../../presentation/components/reward_components/point_history_screen.dart';
import '../../presentation/components/reward_components/reward_details_screen.dart';
import '../../presentation/screens/Blog_Section/comments_screen.dart';
import '../../presentation/screens/Blog_Section/create_post_screen.dart';
import '../../presentation/screens/ai_classification/camera_screen.dart';
import '../../presentation/screens/ai_classification/decide_screen.dart';
import '../../presentation/screens/ai_classification/quetions_screen.dart';
import '../../presentation/screens/auth/auth_screen.dart';
import '../../presentation/screens/navigation_screen.dart';

//
// class AppRouter {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (_) => const SplashScreen());
//       case '/home':
//         return MaterialPageRoute(builder: (_) => const HomeScreen());
//       case '/auth':
//         return MaterialPageRoute(builder: (_) => const AuthScreen());
//       case '/nav':
//         return MaterialPageRoute(builder: (_) => const NavigationScreen());
//       default:
//         return MaterialPageRoute(
//             builder: (_) => Scaffold(
//                   body: Center(
//                       child: Text('No route defined for ${settings.name}')),
//                 ));
//     }
//   }
// }

class RouteNavigation {
  static const String authCheckerScreenRoute = '/';
  static const String homeScreenRoute = '/home';
  static const String authScreenRoute = '/auth';
  static const String communityScreenRoute = '/community';
  static const String navScreenRoute = '/nav';
  static const String leaderboardScreenRoute = '/leaderboard';
  static const String cameraScreenRoute = '/cam';
  static const String pointHistoryScreenRoute = '/pointHistory';
  static const String rewardHistoryScreenRoute = '/rewardHistory';
  static const String createPostScreenRoute = '/createPost';
  static const String commentsScreenRoute = '/comments';
  static const String faqScreenRoute = "/faq";
  static const String helpScreenRoute = "/help";

  /// **generateRoute**
  /// Returns the corresponding route based on the provided route settings.
  static const String quetionsScreenRoute = '/quetions';
  static const String decideScreenRoute = '/decide';

  static const String recycleScreenRoute = "/recycle";
  static const String resellScreenRoute = "/resell";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authCheckerScreenRoute:
        return _customFadeRoute(child: AuthChecker());
      case authScreenRoute:
        return _customFadeRoute(child: const AuthScreen());
      case communityScreenRoute:
        return _customFadeRoute(child: const NavigationScreen());
      case faqScreenRoute:
        return _customFadeRoute(child: const FAQScreen());
      case helpScreenRoute:
        return _customFadeRoute(child: const HelpScreen());
      case recycleScreenRoute:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _customFadeRoute(
            child: RecycleScreen(snapshot: args['snapshot']));
      case resellScreenRoute:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _customFadeRoute(
            child: ResellScreen(snapshot: args['snapshot']));

      case leaderboardScreenRoute:
        return _customFadeRoute(child: const LeaderboardScreen());
      case pointHistoryScreenRoute:
        return _customFadeRoute(child: const PointHistoryScreen());
      case rewardHistoryScreenRoute:
        return _customFadeRoute(child: const RewardDetailsScreen());
      case quetionsScreenRoute:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _customFadeRoute(
            child: QuetionsScreen(
          title: args["title"],
        ));
      case decideScreenRoute:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _customFadeRoute(
            child: DecideScreen(
          qns: args["qns"],
        ));

      case cameraScreenRoute:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _customFadeRoute(child: const CameraScreen());

      // case homeScreenRoute:
      //   return _customFadeRoute(child: const HomeScreen());

      // case resetPasswordScreenRoute:
      //   final args = settings.arguments as Map<String, dynamic>? ?? {};
      //   return _customFadeRoute(
      //       child: ResetPasswordScreen(
      //         username: args["username"],
      //         codeDeliveryDetails: args["codeDeliveryDetails"],
      //       ));

      case navScreenRoute:
        return _customFadeRoute(child: const NavigationScreen());

      case createPostScreenRoute:
        return _customFadeRoute(child: const CreatePostScreen());
      case commentsScreenRoute:
        final postId = settings.arguments as String;
        return _customFadeRoute(child: CommentsScreen(postId: postId));

      // case ConfirmScreenRoute:
      //   return _customFadeRoute(child: const ConfirmScreen());

      // case homeScreenRoute:
      //   return _customFadeRoute(child: HomeScreen());
      //
      // case profileScreenRoute:
      //   return _customFadeRoute(child: ProfileScreen());
      // case playScreenRoute:
      //   final args = settings.arguments as PlayScreen;
      //   return _customFadeRoute(
      //       child: PlayScreen(
      //         initialSchedule: args.initialSchedule,
      //       ));
      default:
        return GetPageRoute(
          page: () => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        );
    }
  }

  /// **_customFadeRoute**
  /// Returns a [PageTransition] with a fade effect.
  static PageTransition _customFadeRoute({required child}) {
    return PageTransition(
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 500),
      child: child,
    );
  }
}
