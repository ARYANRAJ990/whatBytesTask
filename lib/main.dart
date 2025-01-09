import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:world_of_wood/View_Model/UserView_Model.dart';

import 'Utils/Routes/routes.dart';
import 'Utils/Routes/routes_name.dart';
import 'View_Model/AuthView_Model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseAppCheck.instance.activate(

    androidProvider: AndroidProvider.debug, // Use debug provider for testing
    // webRecaptchaSiteKey: 'your-site-key', // Required only for Web
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const	Size(430,932),
      minTextAdapt: true,
      builder: (_, child){
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthViewModel()),
            ChangeNotifierProvider(create: (_) => UserViewModel()),
          ],
          child: MaterialApp(
            title: 'World of Wood',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            initialRoute:  RoutesName.splash,
            onGenerateRoute: Routes.generateRoute,
          ),
        );
      },
    );
  }
}













