// import 'package:flutter/material.dart';
// import '../../../core/services/preferences/pos_config_prefs.dart';
// import '../../../core/routes/app_routes.dart';

// class SplashController extends ChangeNotifier {
//   SplashController();

//   Future<void> init(BuildContext context) async {
//     // Simulate a splash delay
//     await Future.delayed(const Duration(seconds: 3));

//     final bool setupDone = PosConfigPrefs.isConfigComplete();
//     if (!setupDone) {
//       // If setup isn't done, go to region selection
//       Navigator.pushReplacementNamed(context, AppRoutes.selectRegion);
//       return;
//     }

//     // If setup is done, check if the first online login was completed
//     final bool firstOnlineLoginDone = PosConfigPrefs.isFirstOnlineLoginDone();
//     if (!firstOnlineLoginDone) {
//       // If not done, go to online login
//       Navigator.pushReplacementNamed(context, AppRoutes.onlineLogin);
//     } else {
//       // If done, go to offline login
//       Navigator.pushReplacementNamed(context, AppRoutes.offlineLogin);
//     }
//   }
// }
