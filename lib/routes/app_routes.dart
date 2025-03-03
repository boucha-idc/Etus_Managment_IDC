
import 'package:get/get.dart';
import 'package:idc_etus_bechar/view/account/account_screen.dart';
import 'package:idc_etus_bechar/view/account/profile_screen.dart';
import 'package:idc_etus_bechar/view/admin/bus_situation.dart';
import 'package:idc_etus_bechar/view/admin/main_screen.dart';
import 'package:idc_etus_bechar/view/admin/recipe_screen.dart';
import 'package:idc_etus_bechar/view/admin/statistics_screen.dart';
import 'package:idc_etus_bechar/view/admin/worker_details.dart';
import 'package:idc_etus_bechar/view/auth/forget_password_screen.dart';
import 'package:idc_etus_bechar/view/auth/sign_in_screen.dart';
import 'package:idc_etus_bechar/view/controller/bus_evaluation_screen.dart';
import 'package:idc_etus_bechar/view/controller/qr_scan_screen.dart';
import 'package:idc_etus_bechar/view/home_page.dart';
import 'package:idc_etus_bechar/view/splash_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const homePage='/HomePage';
  static const mainPage = '/mainPage';
  static const signIn = '/signIn';
  static const forgetPass = '/forgot_password';
  static const scanQR = '/scanQR';
  static const profile = '/profile';
  static const busEvaluation = '/busEvaluation';
  static const recipeData = '/RecipesScreen';
  static const account = '/account';
  static const busSituation = '/busSituation';
  static const busStatics = '/busStatics';
  static const workerDetails= '/workerDetails';
  static const profileTest= '/test_profile';
  static const dialogRapport= '/dialog_rapport';
  static const String unknownRoleScreen = '/unknown-role';


  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: mainPage, page: () =>const  MainScreen()),
    GetPage(name: homePage, page: () => const  HomePage()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: forgetPass, page: () => const ForgetPasswordScreen()),
    GetPage(name: scanQR, page: () =>  QRScanScreen()),
    GetPage(name: busEvaluation,page:() => BusEvaluationScreen()),
    GetPage(name: profile, page: () =>const ProfileScreen()),
    GetPage(name: account, page: () =>const  AccountScreen()),
    GetPage(name: recipeData, page: () => RecipeScreen()),
    GetPage(name: busSituation, page: () =>const BusSituation()),
    GetPage(name: workerDetails, page: () =>const WorkerDetails()),
    GetPage(name: busStatics , page: () =>StatisticsScreen()),

  ];
}
