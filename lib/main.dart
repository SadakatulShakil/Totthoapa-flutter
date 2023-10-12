import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tottho_apa_flutter/Providers/connectivity_provider.dart';
import 'package:tottho_apa_flutter/Providers/crud_merchant_provider.dart';
import 'package:tottho_apa_flutter/Providers/district_provider.dart';
import 'package:tottho_apa_flutter/Providers/upazila_provider.dart';
import 'package:upgrader/upgrader.dart';

import 'Models/user_model.dart';
import 'Providers/dashboard_provider.dart';
import 'Providers/merchant_provider.dart';
import 'Providers/profile_provider.dart';
import 'Providers/user_provider.dart';
import 'Screens/splash_screen.dart';
import 'Utill/language_constants.dart';
import 'Utill/languages.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await _requestLocationPermission();
  await Upgrader.clearSavedSettings();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String status = prefs.getString('status') ?? '';
  dynamic userId = prefs.getString('user_id') ?? '';
  String userName = prefs.getString('user_name') ?? '';
  String userImage = prefs.getString('user_image') ?? '';
  String fullName = prefs.getString('full_name') ?? '';
  String firstTimeLogged = prefs.getString('first_time_logged') ?? '';

  // Create a User object with the retrieved data
  User user = User(
    status,
    token,
    userId,
    userName,
    userImage,
    fullName,
    firstTimeLogged,
  );
  String storedLanguageCode =
      prefs.getString(LanguageConstants.savedLanguageCode) ?? 'bn';
  String storedLanguageCountryCode =
      prefs.getString(LanguageConstants.savedLanguageCountryCode) ?? 'BD';
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => UserProvider(user)),
      ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ChangeNotifierProvider(create: (_) => MerchantProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => DistrictProvider()),
      ChangeNotifierProvider(create: (_) => UpazilaProvider()),
      ChangeNotifierProvider(create: (_) => CrudMerchantProvider()),
      ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
    ],
        child: MyApp(
          storedLanguageCode: storedLanguageCode,
          storedLanguageCountryCode: storedLanguageCountryCode,
        )
    ),
  );
}

Future<void> _requestLocationPermission() async {
  final PermissionStatus status = await Permission.location.request();
  if (status == PermissionStatus.granted) {
    print('Location permission granted');
  } else {
    print('Location permission denied');
  }
}

class MyApp extends StatelessWidget {
  String storedLanguageCode;
  String storedLanguageCountryCode;
  MyApp(
  {super.key,
  required this.storedLanguageCode,
  required this.storedLanguageCountryCode});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale(storedLanguageCode, storedLanguageCountryCode),
      translations: Languages(),
      fallbackLocale: const Locale('bn', 'BD'),
      title: 'Tottho Apa',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(),
    );
  }
}
